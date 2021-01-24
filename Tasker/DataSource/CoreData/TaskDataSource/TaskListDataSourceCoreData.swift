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
    
    init(context: NSManagedObjectContext, shortcutFilter: String?) {
        self.context = context
        
        super.init()
        
        setupFetchResultsController(shortcutFilter: shortcutFilter)
    }
}

// MARK: TaskListDataSource
extension TaskListDataSourceCoreData: TaskListDataSource {
    func applyShortcutFilter(shortcutFilter: String?) {
        setupFetchResultsController(shortcutFilter: shortcutFilter)
    }
    
    func taskModelForIndexPath(indexPath: IndexPath) -> Task {
        let task = fetchedResultsController.object(at: indexPath)
        return Task(with: task)
    }
        
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
    
    func setDoneForTask(with identifier: String) {
        if let task = taskByIdentifier(identifier: identifier) {
            let taskModel = Task(with: task)
            task.isDone = true
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
    
    func taskForTaskModel(taskModel: Task) -> TaskManaged? {
        if let uuidFilter: UUID = UUID(uuidString: taskModel.uid) {
            return taskByIdentifier(identifier: uuidFilter.uuidString)
        }
        return nil
    }
    
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
            
    var tasksWithSections: [Daily] {
        _ = fetchTasks()
        if let sections = fetchedResultsController.sections {
            var dailyModels = [Daily]()
            
            for section in sections {
                //Create model
                var dailyModel = Daily()
                dailyModel.dailyName = section.name
                
                for task in section.objects! {
                    dailyModel.tasks.append(Task(with: task as! TaskManaged))
                }
                
                dailyModels.append(dailyModel)
            }
            
            return dailyModels
        }
        
        return [Daily]()
    }
    
    var tasks: [TaskManaged] {
        if let fetchedTasks = fetchedResultsController.fetchedObjects {
            return fetchedTasks
        } else {
            return fetchTasks()
        }
    }
    
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
    
    func clearData() {
        let fetchRequest: NSFetchRequest<TaskManaged> = TaskManaged.fetchRequest()

        do {
            let tasksForDelete = try context.fetch(fetchRequest)
            for task in tasksForDelete {
                context.delete(task)
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

extension TaskListDataSourceCoreData: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        observer?.tasksWillChange()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        observer?.tasksDidChange()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let section = IndexSet(integer: sectionIndex)
        
        switch type {
        case .delete:
            observer?.taskSectionDelete(indexSet: section)
        case .insert:
            observer?.taskSectionInsert(indexSet: section)
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
    
    private func setupFetchResultsController(shortcutFilter: String?) {
        // Setting up fetchedResultsController
        let fetchRequest: NSFetchRequest<TaskManaged> = TaskManaged.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "mainTaskListOrder", ascending: true)
        let sortDescriptor2 = NSSortDescriptor(key: "taskDate", ascending: true)
        let sortDescriptor3 = NSSortDescriptor(key: "title", ascending: true)
        
        var predicate = NSPredicate()
        if let shortcutFilter = shortcutFilter {
            guard let shortcutManaged = shortcutByIdentifier(identifier: shortcutFilter) else { return }
            predicate = NSPredicate(format: "isDone == %@ AND shortcut == %@", false, shortcutManaged)
        } else {
            predicate = NSPredicate(format: "isDone == %@", false)
        }
        
        fetchRequest.sortDescriptors = [sortDescriptor, sortDescriptor2, sortDescriptor3]
        fetchRequest.predicate = predicate
        fetchRequest.fetchBatchSize = 20
        // Initialize Fetched Results Controller
        self.fetchedResultsController = NSFetchedResultsController<TaskManaged>(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: "dailyName", cacheName: nil)
        
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
