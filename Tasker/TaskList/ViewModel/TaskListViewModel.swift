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
    var tableViewItems = [DailyModel]()
    
    init(dataSource: TaskListDataSource) {
        self.dataSource = dataSource
        self.dataSource.observer = self
        
        self.tableViewItems = dataSource.tasksWithSections
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
//
//    func addProfile(named userName: String) {
//        dataSource.addProfile(named: userName)
//    }
//
    func clearData() {
        dataSource.clearData()
    }

    func tableViewDidSelectRow(at indexPath: IndexPath) {
        let taskModel = taskModelForIndexPath(indexPath: indexPath)
        view?.editTask(taskModel: taskModel)
    }
    
    func taskModelForIndexPath(indexPath: IndexPath) -> TaskModel {
        return dataSource.taskForIndexPath(indexPath: indexPath)
    }
    
    func addTask(from taskModel: TaskModel) {
        dataSource.addTask(from: taskModel)
    }
    
    func updateTask(from taskModel: TaskModel) {
        dataSource.updateTask(from: taskModel)
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
