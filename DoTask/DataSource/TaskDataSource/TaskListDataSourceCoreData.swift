//
//  TaskListDataSourceCoreData.swift
//  DoTask
//
//  Created by kluv on 27/09/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import CoreData

class TaskListDataSourceCoreData: NSObject {
    // MARK: - Dependencies
    private let context: NSManagedObjectContext
    
    // MARK: - Properites
    weak var observer: TaskListDataSourceObserver?
    private var fetchedResultsController: NSFetchedResultsController<TaskManaged> = NSFetchedResultsController()
    
    // for observe showInMainList property in shortcut
    private var shortcutFecthResultsController: NSFetchedResultsController<ShortcutManaged> = NSFetchedResultsController()
    private let notificationCenter: PushNotificationService = AppDI.resolve()
    
    private let settingsService: SettingService
    
    // MARK: Filters
    
    private var shortcutFilter: String?
    private var onlyFinishedTasksFilter: Bool = false
    private var dayFilter: Date?
    
    // MARK: Init
    
    init(coreDataService: CoreDataService, settingsService: SettingService) {
        self.context = coreDataService.context
        self.settingsService = settingsService
        
        super.init()
        
        setupFetchResultsController()
        setupShortcutFecthResultsController()
    }
}

// MARK: TaskListDataSource
extension TaskListDataSourceCoreData: TaskListDataSource {
    
    func reloadData() {
        setupFetchResultsController()
    }
    
    func applyFilters(filter: TaskListFilter) {
        self.shortcutFilter = filter.shortcutFilter
        self.dayFilter = filter.dayFilter
        setupFetchResultsController()
    }
    
    func setOnlyDoneTasksMode() {
        onlyFinishedTasksFilter = true
        setupFetchResultsController()
    }
    
    func taskModelForIndexPath(indexPath: IndexPath) -> Task {
        let task = fetchedResultsController.object(at: indexPath)
        return Task(with: task)
    }
            
    // MARK: Get tasks by date
    
    func getTasksByDate() -> [Date:CalendarDayStatus] {
        
        var result: [Date:CalendarDayStatus] = [:]
        
        let fetchRequest: NSFetchRequest<TaskManaged> = TaskManaged.fetchRequest()
        
        var predicates: [NSPredicate] = []
        
        if let shortcutFilter = shortcutFilter {
            guard let shortcutManaged = shortcutByIdentifier(identifier: shortcutFilter) else { return result }
            predicates.append(NSPredicate(format: "shortcut == %@", shortcutManaged))
        }
        
        let sortDescriptor = NSSortDescriptor(key: "taskDate", ascending: true)
        
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let tasks = try context.fetch(fetchRequest)
            
            result = tasks.filter {
                $0.taskDate != nil
            }.reduce(into: result) { acc, taskManaged in
                let taskDay = taskManaged.taskDate!.startOfDay()
                let exist = acc[taskDay] ?? (taskManaged.isDone ? CalendarDayStatus.allDone : CalendarDayStatus.inProgress)
                
                if (exist == .allDone && !taskManaged.isDone) || (exist == .inProgress && taskManaged.isDone) {
                    acc[taskDay] = .doneAndProgress
                } else {
                    acc[taskDay] = exist
                }
            }
                        
            return result
                        
        } catch {
            fatalError()
        }
    }
        
    // MARK: Get first task date
    
    func getFirstTaskDate() -> Date? {
        let fetchRequest: NSFetchRequest<TaskManaged> = TaskManaged.fetchRequest()
        
        let predicate = NSPredicate(format: "taskDate != nil")
        let sortDescriptor = NSSortDescriptor(key: "taskDate", ascending: true)
        
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        var firstDate: Date?
        
        do {
            let tasks = try context.fetch(fetchRequest)
            
            if tasks.isEmpty {
                return nil
            }
            
            firstDate = tasks[0].taskDate
        } catch {
            fatalError()
        }
        
        return firstDate
    }
        
    // MARK: Get task model by UID
    
    func taskModelByIdentifier(identifier: String?) -> Task? {
        guard let identifier = identifier else { return nil }
        if let uuid = UUID(uuidString: identifier) {
            let fetchRequest: NSFetchRequest<TaskManaged> = TaskManaged.fetchRequest()
            let predicate = NSPredicate(format: "identificator == %@", uuid as NSUUID)
            
            fetchRequest.predicate = predicate
            
            do {
                let tasks = try context.fetch(fetchRequest)
                
                if tasks.isEmpty {
                    return nil
                }
                
                return Task(with: tasks[0])
            } catch {
                fatalError()
            }
        }
        
        return nil
    }
    
    // MARK: Get task managed by UID
    
    func taskByIdentifier(identifier: String) -> TaskManaged? {
        if let uuid = UUID(uuidString: identifier) {
            let fetchRequest: NSFetchRequest<TaskManaged> = TaskManaged.fetchRequest()
            let predicate = NSPredicate(format: "identificator == %@", uuid as NSUUID)
            
            fetchRequest.predicate = predicate
            
            do {
                let tasks = try context.fetch(fetchRequest)
                
                if tasks.isEmpty {
                    return nil
                }
                
                return tasks[0]
            } catch {
                fatalError()
            }
        }
        
        return nil
    }
        
    // MARK: Get shortcut managed by UID
    
    func shortcutByIdentifier(identifier: String) -> ShortcutManaged? {
        if let uuid = UUID(uuidString: identifier) {
            let fetchRequest: NSFetchRequest<ShortcutManaged> = NSFetchRequest(entityName: "ShortcutManaged")
            let predicate = NSPredicate(format: "identificator == %@", uuid as NSUUID)

            fetchRequest.predicate = predicate
            
            do {
                let shortcuts = try context.fetch(fetchRequest)
                
                if shortcuts.isEmpty {
                    return nil
                }
                
                return shortcuts[0]
            } catch {
                fatalError()
            }
        }
        
        return nil
    }
    
    // MARK: Get shortcut model by UID
    
    func shortcutModelByIdentifier(identifier: String) -> Shortcut? {
        if let uuid = UUID(uuidString: identifier) {
            let fetchRequest: NSFetchRequest<ShortcutManaged> = NSFetchRequest(entityName: "ShortcutManaged")
            let predicate = NSPredicate(format: "identificator == %@", uuid as NSUUID)

            fetchRequest.predicate = predicate
            
            do {
                let shortcuts = try context.fetch(fetchRequest)
                
                if shortcuts.isEmpty {
                    return nil
                }
                
                return Shortcut(with: shortcuts[0])
            } catch {
                fatalError()
            }
        }
        
        return nil
    }
    
    // MARK: Set done
    
    func setDoneForTask(with identifier: String) {
        if let task = taskByIdentifier(identifier: identifier) {
            let taskModel = Task(with: task)
            task.isDone = true
            task.doneDate = Date()
            do {
                try context.save()
                
                let notifyModel = DateNotifier(with: taskModel)
                notificationCenter.deleteLocalNotifications(identifiers: [notifyModel.identifier])
            } catch {
                fatalError()
            }
        }
    }
    
    // MARK: Unset Done
    func unsetDoneForTask(with identifier: String) {
        if let task = taskByIdentifier(identifier: identifier) {
            let taskModel = Task(with: task)
            task.isDone = false
            task.doneDate = nil
            do {
                try context.save()
                
                let notifyModel = DateNotifier(with: taskModel)
                if taskModel.reminderDate {
                    notificationCenter.addLocalNotification(notifyModel: notifyModel)
                }
            } catch {
                fatalError()
            }
        }
    }
    
    // MARK: Get taskManaged from model
    
    func taskForTaskModel(taskModel: Task) -> TaskManaged? {
        if let uuidFilter: UUID = UUID(uuidString: taskModel.uid) {
            return taskByIdentifier(identifier: uuidFilter.uuidString)
        }
        return nil
    }
    
    // MARK: Delete task
    
    func deleteTask(from taskModel: Task) {
        if let task = taskForTaskModel(taskModel: taskModel) {
            context.delete(task)
            do {
                try context.save()
                
                let notifyModel = DateNotifier(with: taskModel)
                notificationCenter.deleteLocalNotifications(identifiers: [notifyModel.identifier])
            } catch {
                fatalError()
            }
        }
    }
        
    // MARK: Get tasks with sections
    
    var tasksWithSections: [TaskTimePeriod] {
        _ = fetchTasks()
        if let sections = fetchedResultsController.sections {
            var dailyModels = [TaskTimePeriod]()
            
            for section in sections {
                //Create model
                var dailyModel = TaskTimePeriod()
                
                if onlyFinishedTasksFilter {
                    let dateFormatter = DateFormatter()
                    
                    dateFormatter.timeZone = TimeZone.autoupdatingCurrent
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                    
                    if let sectionDate = dateFormatter.date(from: section.name) {
                        dateFormatter.dateFormat = "dd MMMM yyyy"
                        dailyModel.name = dateFormatter.string(from: sectionDate)
                    }
                } else if let _ = dayFilter {
                    let dateFormatter = DateFormatter()
                    
                    dateFormatter.timeZone = TimeZone.autoupdatingCurrent
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                    
                    if let sectionDate = dateFormatter.date(from: section.name) {
                        dateFormatter.dateFormat = "dd MMMM"
                        dailyModel.name = dateFormatter.string(from: sectionDate)
                    }
                } else {
                    dailyModel.dailyName = DailyName(rawValue: section.name)
                }
                
                for task in section.objects! {
                    dailyModel.tasks.append(Task(with: task as! TaskManaged))
                }
                
                dailyModels.append(dailyModel)
            }
            
            return dailyModels
        }
        
        return [TaskTimePeriod]()
    }
        
    // MARK: Get tasks
    
    var tasks: [TaskManaged] {
        if let fetchedTasks = fetchedResultsController.fetchedObjects {
            return fetchedTasks
        } else {
            return fetchTasks()
        }
    }
    
    // MARK: Add task
    
    func addTask(from task: Task) {
        let newTask = TaskManaged(context: context)
        
        if let uuid: UUID = UUID(uuidString: task.uid) {
            
            newTask.identificator = uuid
            newTask.title = task.title.trimmingCharacters(in: .whitespacesAndNewlines)
            newTask.taskDate = task.taskDate
            newTask.reminderDate = task.reminderDate
            newTask.reminderGeo = task.reminderGeo
            newTask.importanceLevel = task.importanceLevel
            newTask.mainTaskListOrder = task.taskDate == nil ? 1 : 0
            newTask.isDone = false
            newTask.sortDate = task.sortDate
            
            if settingsService.getSettings().task.newTaskTime == .startDay {
                //get all task for daily period and calculate lower date
                let dailyPeriod = task.taskDate?.dailyNameForTask() ?? .later
                
                let fetchTasksForPeriod: NSFetchRequest<TaskManaged> = TaskManaged.fetchRequest()
                fetchTasksForPeriod.sortDescriptors = [NSSortDescriptor(key: "sortDate", ascending: true)]
                fetchTasksForPeriod.predicate = getPredicateForDailyPeriod(dailyPeriod: dailyPeriod)
                
                do {
                    let periodTasks = try context.fetch(fetchTasksForPeriod)
                    if let firstTask = periodTasks.first {
                        newTask.sortDate = firstTask.sortDate - 1
                    }
                } catch {
                    fatalError()
                }
            }
            
            if let shortcut = task.shortcut {
                newTask.shortcut = shortcutByIdentifier(identifier: shortcut.uid)
            }
            
            if let lat = task.lat, let lon = task.lon {
                newTask.lat = lat
                newTask.lon = lon
            }
            
            task.subtasks.forEach {
                let newSubtask = SubtaskManaged(context: context)
                newSubtask.isDone = $0.isDone
                newSubtask.title = $0.title.trimmingCharacters(in: .whitespacesAndNewlines)
                newSubtask.priority = $0.priority
                newSubtask.task = newTask
            }
            
            do {
                try context.save()
                if task.reminderDate {
                    let notifyModel = DateNotifier(with: task)
                    notificationCenter.addLocalNotification(notifyModel: notifyModel)
                }
            } catch {
                fatalError()
            }
        }
    }
    
    // MARK: Update task
    
    func updateTask(from task: Task) {
        if let taskManaged = taskForTaskModel(taskModel: task) {
            
            //change sortDate if change period in task
            let oldDailyPeriod = taskManaged.taskDate?.dailyNameForTask()
            let newDailyPeriod = task.taskDate?.dailyNameForTask() ?? DailyName.later
            
            if oldDailyPeriod != newDailyPeriod {
                let fetchTasksForPeriod: NSFetchRequest<TaskManaged> = TaskManaged.fetchRequest()
                fetchTasksForPeriod.sortDescriptors = [NSSortDescriptor(key: "sortDate", ascending: true)]
                fetchTasksForPeriod.predicate = getPredicateForDailyPeriod(dailyPeriod: newDailyPeriod)
                
                do {
                    let periodTasks = try context.fetch(fetchTasksForPeriod)
                    if let lastTask = periodTasks.last {
                        taskManaged.sortDate = lastTask.sortDate + 1
                    }
                } catch {
                    fatalError()
                }
                
            }
            
            taskManaged.title = task.title.trimmingCharacters(in: .whitespacesAndNewlines)
            taskManaged.taskDate = task.taskDate
            taskManaged.reminderDate = task.reminderDate
            taskManaged.reminderGeo = task.reminderGeo
            taskManaged.lat = task.lat!
            taskManaged.lon = task.lon!
            taskManaged.importanceLevel = task.importanceLevel
            taskManaged.mainTaskListOrder = task.taskDate == nil ? 1 : 0
            
            if let shortcut = task.shortcut {
                taskManaged.shortcut = shortcutByIdentifier(identifier: shortcut.uid)
            }
            
            taskManaged.subtasks.forEach {
                context.delete($0 as! NSManagedObject)
            }
            
            task.subtasks.forEach {
                let newSubtask = SubtaskManaged(context: context)
                newSubtask.isDone = $0.isDone
                newSubtask.title = $0.title.trimmingCharacters(in: .whitespacesAndNewlines)
                newSubtask.priority = $0.priority
                newSubtask.task = taskManaged
            }
            
            do {
                try context.save()
                
                let notifyModel = DateNotifier(with: task)
                                
                notificationCenter.deleteLocalNotifications(identifiers: [notifyModel.identifier])
                if task.reminderDate {
                    notificationCenter.addLocalNotification(notifyModel: notifyModel)
                }
            } catch {
                fatalError()
            }
        }
    }
    
    private func getPredicateForDailyPeriod(dailyPeriod: DailyName) -> NSPredicate {
        
        var predicate: NSPredicate = NSPredicate()
        
        switch dailyPeriod {
        case .today:
            predicate = NSPredicate(format: "taskDate <= %@", Date().endOfDay() as NSDate)
        case .tommorow:
            guard let tommorowDay = Calendar.current.taskCalendar.date(byAdding: .day, value: 1, to: Date()) else { return predicate}
            predicate = NSPredicate(format: "taskDate >= %@ AND taskDate <= %@", tommorowDay.startOfDay() as NSDate, tommorowDay.endOfDay() as NSDate)
        case .currentWeek:
            guard let afterTommorowDay = Calendar.current.taskCalendar.date(byAdding: .day, value: 2, to: Date()) else { return predicate}
            guard let endOfWeek = Date().endOfWeek else { return predicate }
            predicate = NSPredicate(format: "taskDate >= %@ AND taskDate <= %@", afterTommorowDay.startOfDay() as NSDate, endOfWeek.endOfDay() as NSDate)
        case .later:
            guard let endOfWeek = Date().endOfWeek else { return predicate }
            predicate = NSPredicate(format: "taskDate > %@ OR taskDate = nil", endOfWeek.startOfDay() as NSDate)
        }
        
        return predicate
    }
    
    // MARK: Done counter
    
    func getDoneCounterForPeriod(dailyPeriod: DailyName, taskListFilter: TaskListFilter? = nil) -> DoneCounter? {
        if !dailyPeriod.haveDoneCounter() {
            return nil
        }
        
        let fetchTasksForPeriod: NSFetchRequest<TaskManaged> = TaskManaged.fetchRequest()
        let donePredicate = NSPredicate(format: "isDone == %@", NSNumber(value: true))
        
        var predicates: [NSPredicate] = [NSPredicate(format: "doneDate <= %@ AND doneDate => %@", Date().endOfDay() as NSDate, Date().startOfDay() as NSDate)]
                
        var shortcutPredicate: NSPredicate?
        
        if let taskListFilter = taskListFilter {
            if let shortcutFilter = taskListFilter.shortcutFilter {
                if let uuid = UUID(uuidString: shortcutFilter) {
                    shortcutPredicate = NSPredicate(format: "shortcut.identificator == %@", uuid as NSUUID)
                }
            }
        }
        
        if shortcutPredicate == nil {
            shortcutPredicate = NSPredicate(format: "shortcut.showInMainList == %@ OR shortcut == nil", NSNumber(value: true))
        }
        
        guard let shortcutPredicate = shortcutPredicate else { return nil }
        
        predicates.append(shortcutPredicate)
        predicates.append(donePredicate)
        
        fetchTasksForPeriod.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        var doneCount = 0
        var allCount = 0
        
        do {
            let periodTasks = try context.fetch(fetchTasksForPeriod)
            doneCount = periodTasks.count
        } catch {
            fatalError()
        }
        
        predicates.append(getPredicateForDailyPeriod(dailyPeriod: dailyPeriod))
                
        let predicates2 = NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "isDone == %@", NSNumber(value: false)), shortcutPredicate, getPredicateForDailyPeriod(dailyPeriod: dailyPeriod)])
        
        fetchTasksForPeriod.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [NSCompoundPredicate(andPredicateWithSubpredicates: predicates), predicates2])
        
        do {
            let periodTasks = try context.fetch(fetchTasksForPeriod)
            allCount = periodTasks.count
        } catch {
            fatalError()
        }
        
        return DoneCounter(allCount: allCount, doneCount: doneCount)
    }
    
    // MARK: Clear data
    
    func clearData() {
        let requestTasks: NSFetchRequest<TaskManaged> = TaskManaged.fetchRequest()

        do {
            let tasksForDelete = try context.fetch(requestTasks)
            for task in tasksForDelete {
                context.delete(task)
            }
        } catch {
            fatalError()
        }
        
        let requestShortcuts: NSFetchRequest<ShortcutManaged> = ShortcutManaged.fetchRequest()
        
        do {
            let shortcutsForDelete = try context.fetch(requestShortcuts)
            for shortcut in shortcutsForDelete {
                context.delete(shortcut)
            }
        } catch {
            fatalError()
        }
        
        do {
            try context.save()
        } catch {
            fatalError()
        }
    }
}

// MARK: Task FRC Delegate

extension TaskListDataSourceCoreData: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        observer?.tasksWillChange()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        observer?.tasksDidChange()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .delete:
            observer?.taskSectionDelete(section: sectionIndex)
        case .insert:
            observer?.taskSectionInsert(section: sectionIndex)
        case .move:
            return
        case .update:
            return
        @unknown default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        if shortcutFecthResultsController == controller, let shortcutManaged = anObject as? ShortcutManaged {
            context.perform {
                shortcutManaged.tasks.forEach {
                    if let taskManaged = $0 as? TaskManaged {
                        taskManaged.shortcut = shortcutManaged
                    }
                }
            }
            return
        }
        
        switch type {
        case .delete:
            observer?.taskDeleted(at: indexPath!)
        case .insert:
            if let indexPath = newIndexPath {
                observer?.taskInserted(at: indexPath)
            }
        case .move:
            if let indexPath = indexPath {
                observer?.taskDeleted(at: indexPath)
            }
            if let newIndexPath = newIndexPath {
                observer?.taskInserted(at: newIndexPath)
                
            }
        case .update:
            if let indexPath = indexPath {
                observer?.taskUpdated(at: indexPath)
            }
        default:
            break
        }
        
    }
    
}

// MARK: Maintaince

extension TaskListDataSourceCoreData: TasksMaintainceDataSource {
    func transferOverdueTasks() {
        let fetchTasks: NSFetchRequest<TaskManaged> = TaskManaged.fetchRequest()
        fetchTasks.predicate = NSPredicate(format: "taskDate < %@ AND isDone == %@", Date().startOfDay() as NSDate, NSNumber(value: false))
        
        do {
            let tasksOverdue = try context.fetch(fetchTasks)
            
            tasksOverdue.forEach {
                $0.taskDate = Date().startOfDay()
            }
            
            try context.save()
        } catch {
            fatalError()
        }
    }
    
    func getAllTasks() -> [Task] {
        let fetchTasks: NSFetchRequest<TaskManaged> = TaskManaged.fetchRequest()
        var tasks: [Task] = []
        
        do {
            let fetchedTasks = try context.fetch(fetchTasks)
            
            fetchedTasks.forEach {
                tasks.append(Task(with: $0))
            }
            
            return tasks
        } catch {
            fatalError()
        }
    }
}

// MARK: FRC
extension TaskListDataSourceCoreData {
    
    private func setupShortcutFecthResultsController() {
        let fetchRequest: NSFetchRequest<ShortcutManaged> = ShortcutManaged.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        shortcutFecthResultsController = NSFetchedResultsController<ShortcutManaged>(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        shortcutFecthResultsController.delegate = self
        
        do {
            try shortcutFecthResultsController.performFetch()
        } catch {
            fatalError()
        }
    }
    
    private func setupFetchResultsController() {
        // Setting up fetchedResultsController
        let fetchRequest: NSFetchRequest<TaskManaged> = TaskManaged.fetchRequest()
        
        let taskListOrderSort = NSSortDescriptor(key: "mainTaskListOrder", ascending: true)
        let taskDateSort = NSSortDescriptor(key: "taskDate", ascending: true)
        let taskCreateDateSort = NSSortDescriptor(key: "sortDate", ascending: true)
        let doneDateSort = NSSortDescriptor(key: "doneDate", ascending: false)
                
        var sectionNameKeyPath = "dailyName"
                
        var predicates: [NSPredicate] = []
        let taskListSortDescriptors: [NSSortDescriptor] = [taskListOrderSort, taskDateSort, taskCreateDateSort]
        let taskDiarySortDescriptors: [NSSortDescriptor] = [doneDateSort]
        
        fetchRequest.sortDescriptors = taskListSortDescriptors
        
        if let shortcutFilter = shortcutFilter {
            guard let shortcutManaged = shortcutByIdentifier(identifier: shortcutFilter) else { return }
            predicates.append(NSPredicate(format: "shortcut == %@", shortcutManaged))
        } else if !onlyFinishedTasksFilter  {
            predicates.append(NSPredicate(format: "shortcut.showInMainList == %@ OR shortcut == nil", NSNumber(value: true)))
        }
        
        if let dayFilter = dayFilter {
            predicates.append(NSPredicate(format: "taskDate >= %@ AND taskDate <= %@", dayFilter.startOfDay() as NSDate, dayFilter.endOfDay() as NSDate))
            sectionNameKeyPath = "taskDay"
        } else {
            var donePredicates: [NSPredicate] = []
            donePredicates.append(NSPredicate(format: "isDone == %@", NSNumber(value: onlyFinishedTasksFilter)))
            
            //Settings for show done tasks
            let settingsService: SettingService = AppDI.resolve()
                     
            if settingsService.getSettings().task.showDoneTasksInToday {
                donePredicates.append(NSPredicate(format: "taskDate <= %@ AND taskDate >= %@ AND isDone == %@", Date().endOfDay() as NSDate, Date().startOfDay() as NSDate, NSNumber(value: true)))
            }
            
            let doneCompaundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: donePredicates)
            predicates.append(doneCompaundPredicate)
        }
        
        if onlyFinishedTasksFilter {
            sectionNameKeyPath = "doneDay"
            fetchRequest.sortDescriptors = taskDiarySortDescriptors
        }
        
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        // Initialize Fetched Results Controller
        self.fetchedResultsController = NSFetchedResultsController<TaskManaged>(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: sectionNameKeyPath, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
    }
    
    private func fetchTasks() -> [TaskManaged] {
        do {
            try fetchedResultsController.performFetch()
            return fetchedResultsController.fetchedObjects ?? []
        } catch {
            fatalError()
        }
    }
}
