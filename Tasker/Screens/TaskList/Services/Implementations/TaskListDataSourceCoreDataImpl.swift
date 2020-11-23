//
//  TaskListDataSourceCoreData.swift
//  Tasker
//
//  Created by kluv on 27/09/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import CoreData

class TaskListDataSourceCoreDataImpl: NSObject {
    // MARK: - Dependencies
    private let context: NSManagedObjectContext
    
    // MARK: - Properites
    weak var observer: TaskListDataSourceObserver?
    private let fetchedResultsController: NSFetchedResultsController<Task>
    private let notificationCenter = PushNotificationService.shared
    
    init(context: NSManagedObjectContext) {
        self.context = context
            
        // Setting up fetchedResultsController
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "mainTaskListOrder", ascending: true)
        let sortDescriptor2 = NSSortDescriptor(key: "taskDate", ascending: true)
        let sortDescriptor3 = NSSortDescriptor(key: "title", ascending: true)
        
        let predicate = NSPredicate(format: "isDone == %@", false)
        
        fetchRequest.sortDescriptors = [sortDescriptor, sortDescriptor2, sortDescriptor3]
        fetchRequest.predicate = predicate
        fetchRequest.fetchBatchSize = 20
        // Initialize Fetched Results Controller
        self.fetchedResultsController = NSFetchedResultsController<Task>(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: "dailyName", cacheName: nil)
        
        super.init()
        
        fetchedResultsController.delegate = self
    }
}

// MARK: TaskListDataSource
extension TaskListDataSourceCoreDataImpl: TaskListDataSource {
    func taskModelForIndexPath(indexPath: IndexPath) -> TaskModel {
        let task = fetchedResultsController.object(at: indexPath)
        return TaskModel(with: task)
    }
    
    func taskModelByIdentifier(identifier: String?) -> TaskModel? {
        guard let identifier = identifier else { return nil }
        if let uuid = UUID(uuidString: identifier) {
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
            let predicate = NSPredicate(format: "identificator == %@", uuid as NSUUID)
            
            fetchRequest.predicate = predicate
            
            do {
                let tasks = try context.fetch(fetchRequest)
                
                if tasks.isEmpty {
                    return nil
                }
                
                return TaskModel(with: tasks[0])
            } catch {
                fatalError()
            }
        }
        
        return nil
    }
    
    func taskByIdentifier(identifier: String) -> Task? {
        if let uuid = UUID(uuidString: identifier) {
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
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
    
    func setDoneForTask(with identifier: String) {
        if let task = taskByIdentifier(identifier: identifier) {
            let taskModel = TaskModel(with: task)
            task.isDone = true
            do {
                try context.save()
                
                let notifyModel = NotifyByDateModel(with: taskModel)
                notificationCenter.deleteLocalNotifications(identifiers: [notifyModel.identifier])
                if taskModel.reminderDate {
                    notificationCenter.addLocalNotification(notifyModel: notifyModel)
                }
            } catch {
                fatalError()
            }
        }
    }
    
    func taskForTaskModel(taskModel: TaskModel) -> Task? {
        if let uuidFilter: UUID = UUID(uuidString: taskModel.uid) {
            return taskByIdentifier(identifier: uuidFilter.uuidString)
        }
        return nil
    }
    
    func deleteTask(from taskModel: TaskModel) {
        if let task = taskForTaskModel(taskModel: taskModel) {
            context.delete(task)
            do {
                try context.save()
                
                let notifyModel = NotifyByDateModel(with: taskModel)
                notificationCenter.deleteLocalNotifications(identifiers: [notifyModel.identifier])
                if taskModel.reminderDate {
                    notificationCenter.addLocalNotification(notifyModel: notifyModel)
                }
            } catch {
                fatalError()
            }
        }
    }
        
    func updateTask(from taskModel: TaskModel) {
        if let task = taskForTaskModel(taskModel: taskModel) {
            task.title = taskModel.title
            task.taskDate = taskModel.taskDate
            task.reminderDate = taskModel.reminderDate
            task.reminderGeo = taskModel.reminderGeo
            task.lat = taskModel.lat!
            task.lon = taskModel.lon!
            task.importanceLevel = taskModel.importanceLevel
            task.mainTaskListOrder = taskModel.taskDate == nil ? 1 : 0
            
            do {
                try context.save()
                
                let notifyModel = NotifyByDateModel(with: taskModel)
                notificationCenter.deleteLocalNotifications(identifiers: [notifyModel.identifier])
                if taskModel.reminderDate {
                    notificationCenter.addLocalNotification(notifyModel: notifyModel)
                }
            } catch {
                fatalError()
            }
        }
    }
    
    var tasksWithSections: [DailyModel] {
        _ = fetchTasks()
        if let sections = fetchedResultsController.sections {
            var dailyModels = [DailyModel]()
            
            for section in sections {
                //Create model
                var dailyModel = DailyModel()
                dailyModel.dailyName = section.name
                
                for task in section.objects! {
                    dailyModel.tasks.append(TaskModel(with: task as! Task))
                }
                
                dailyModels.append(dailyModel)
            }
            
            return dailyModels
        }
        
        return [DailyModel]()
    }
    
    var tasks: [Task] {
        if let fetchedTasks = fetchedResultsController.fetchedObjects {
            return fetchedTasks
        } else {
            return fetchTasks()
        }
    }
    
    func addTask(from taskModel: TaskModel) {
        let newTask = Task(context: context)
        
        if let uuid: UUID = UUID(uuidString: taskModel.uid) {
            
            newTask.identificator = uuid
            newTask.title = taskModel.title
            newTask.taskDate = taskModel.taskDate
            newTask.reminderDate = taskModel.reminderDate
            newTask.reminderGeo = taskModel.reminderGeo
            newTask.importanceLevel = taskModel.importanceLevel
            newTask.mainTaskListOrder = taskModel.taskDate == nil ? 1 : 0
            
            if let lat = taskModel.lat, let lon = taskModel.lon {
                newTask.lat = lat
                newTask.lon = lon
            }
            
            do {
                try context.save()
                if taskModel.reminderDate {
                    let notifyModel = NotifyByDateModel(with: taskModel)
                    notificationCenter.addLocalNotification(notifyModel: notifyModel)
                }
            } catch {
                fatalError()
            }
            
        }
    }
    
    func clearData() {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()

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

extension TaskListDataSourceCoreDataImpl: NSFetchedResultsControllerDelegate {
    
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

// MARK: Util
extension TaskListDataSourceCoreDataImpl {
    func fetchTasks() -> [Task] {
        do {
            try fetchedResultsController.performFetch()
            return fetchedResultsController.fetchedObjects ?? []
        } catch {
            fatalError()
        }
    }
}