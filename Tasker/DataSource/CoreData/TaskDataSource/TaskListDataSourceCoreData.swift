//
//  TaskListDataSourceCoreData.swift
//  Tasker
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
    private let notificationCenter = PushNotificationService.shared
    
    // MARK: Filters
    
    private var shortcutFilter: String?
    private var onlyFinishedTasksFilter: Bool
    
    // MARK: Init
    
    init(context: NSManagedObjectContext, shortcutFilter: String?, onlyFinishedTasksFilter: Bool = false) {
        self.context = context
        self.shortcutFilter = shortcutFilter
        self.onlyFinishedTasksFilter = onlyFinishedTasksFilter
        
        super.init()
        
        setupFetchResultsController()
    }
}

// MARK: TaskListDataSource
extension TaskListDataSourceCoreData: TaskListDataSource {
//    func applyShortcutFilter(shortcutFilter: String?) {
//        self.shortcutFilter = shortcutFilter
//        self.onlyFinishedTasksFilter = false
//        setupFetchResultsController()
//    }
//
//    func applyTaskDiaryMode() {
//        self.shortcutFilter = nil
//        self.onlyFinishedTasksFilter = true
//        setupFetchResultsController()
//    }
    
    func applyFilters(filter: TaskListFilter) {
        self.shortcutFilter = filter.shortcutFilter
        self.onlyFinishedTasksFilter = filter.taskDiaryMode
        setupFetchResultsController()
    }
    
    func taskModelForIndexPath(indexPath: IndexPath) -> Task {
        let task = fetchedResultsController.object(at: indexPath)
        return Task(with: task)
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
                        dateFormatter.dateFormat = "dd/MM/yyyy"
                        dailyModel.name = dateFormatter.string(from: sectionDate)
                    }
                } else {
                    dailyModel.name = section.name
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
            newTask.title = task.title
            newTask.taskDate = task.taskDate
            newTask.reminderDate = task.reminderDate
            newTask.reminderGeo = task.reminderGeo
            newTask.importanceLevel = task.importanceLevel
            newTask.mainTaskListOrder = task.taskDate == nil ? 1 : 0
            
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
                newSubtask.title = $0.title
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
            taskManaged.title = task.title
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
                newSubtask.title = $0.title
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
    
    // MARK: Clear data
    
    func clearData() {
        let fetchRequest: NSFetchRequest<TaskManaged> = TaskManaged.fetchRequest()

        do {
            let tasksForDelete = try context.fetch(fetchRequest)
            for task in tasksForDelete {
                if task.isDone && task.doneDate == nil {
                    context.delete(task)
                }
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

// MARK: NSFetchedResultsControllerDelegate

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

// MARK: FRC
extension TaskListDataSourceCoreData {
    
    private func setupFetchResultsController() {
        // Setting up fetchedResultsController
        let fetchRequest: NSFetchRequest<TaskManaged> = TaskManaged.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "mainTaskListOrder", ascending: true)
        let sortDescriptor2 = NSSortDescriptor(key: "taskDate", ascending: true)
        let sortDescriptor3 = NSSortDescriptor(key: "title", ascending: true)
        
        var predicate = NSPredicate()
        var sectionNameKeyPath = "dailyName"
        
        if let shortcutFilter = shortcutFilter {
            guard let shortcutManaged = shortcutByIdentifier(identifier: shortcutFilter) else { return }
            predicate = NSPredicate(format: "isDone == %@ AND shortcut == %@", false, shortcutManaged)
            fetchRequest.sortDescriptors = [sortDescriptor, sortDescriptor2, sortDescriptor3]
        } else if onlyFinishedTasksFilter {
            predicate = NSPredicate(format: "isDone == true")
            sectionNameKeyPath = "doneDay"
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "doneDate", ascending: false)]
        } else {
            predicate = NSPredicate(format: "isDone == %@", false)
            fetchRequest.sortDescriptors = [sortDescriptor, sortDescriptor2, sortDescriptor3]
        }
        
        fetchRequest.predicate = predicate
        fetchRequest.fetchBatchSize = 20
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
