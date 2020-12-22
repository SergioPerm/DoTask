//
//  TaskListViewModel.swift
//  Tasker
//
//  Created by kluv on 27/09/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import Foundation

class TaskListViewModel {
    // MARK: - Dependencies
    weak var view: TaskListView?
    private var dataSource: TaskListDataSource

    // MARK: - Properties
    var tableViewItems = [Daily]()
    
    init(dataSource: TaskListDataSource) {
        self.dataSource = dataSource
        self.dataSource.observer = self
        
        self.tableViewItems = dataSource.tasksWithSections
        
        PushNotificationService.shared.attachObserver(self)
    }
    
}

// MARK: - Exposed functions
extension TaskListViewModel {
    func viewWillAppear(view: TaskListView) {
        self.view = view
    }

    func viewWillDisappear() {
        self.view = nil
    }

    func clearData() {
        dataSource.clearData()
    }

    func tableViewDidSelectRow(at indexPath: IndexPath) {
        let taskModel = taskModelForIndexPath(indexPath: indexPath)
        view?.editTask(taskModel: taskModel)
    }
    
    func taskModelForIndexPath(indexPath: IndexPath) -> Task {
        return dataSource.taskModelForIndexPath(indexPath: indexPath)
    }
    
    func addTask(from taskModel: Task) {
        dataSource.addTask(from: taskModel)
    }
    
    func updateTask(from taskModel: Task) {
        dataSource.updateTask(from: taskModel)
    }
    
    func deleteTask(at indexPath: IndexPath) {
        let taskModel = taskModelForIndexPath(indexPath: indexPath)
        dataSource.deleteTask(from: taskModel)
    }
    
    func setDoneForTask(with taskIdentifier: String) {
        dataSource.setDoneForTask(with: taskIdentifier)
    }
}

extension TaskListViewModel: TaskListDataSourceObserver {
    func tasksWillChange() {
        view?.tableViewBeginUpdates()
    }
    
    func tasksDidChange() {
        tableViewItems = dataSource.tasksWithSections
        view?.tableViewEndUpdates()
    }
    
    func taskSectionDelete(indexSet: IndexSet) {
        view?.tableViewSectionDelete(at: indexSet)
    }
    
    func taskSectionInsert(indexSet: IndexSet) {
        view?.tableViewSectionInsert(at: indexSet)
    }
    
    func taskInserted(at newIndexPath: IndexPath) {
        view?.tableViewInsertRow(at: newIndexPath)
    }
    
    func taskDeleted(at indexPath: IndexPath) {
        view?.tableViewDeleteRow(at: indexPath)
    }
    
    func taskUpdated(at indexPath: IndexPath) {
        view?.tableViewUpdateRow(at: indexPath)
    }
}

// MARK: NotificationTaskObserver

extension TaskListViewModel: NotificationTaskObserver {
    func onTapNotification(with id: String) {
        if let task = dataSource.taskByIdentifier(identifier: id) {
            let taskModel = Task(with: task)
            view?.editTask(taskModel: taskModel)
        }
    }
}
