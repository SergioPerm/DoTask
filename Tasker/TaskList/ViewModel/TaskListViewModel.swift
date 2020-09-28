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
internal extension TaskListViewModel {
//    func viewWillAppear(view: ProfileListView) {
//        self.view = view
//        view.tableViewReload()
//    }
//
//    func viewWillDisappear() {
//        self.view = nil
//    }
//
//    func addProfile(named userName: String) {
//        dataSource.addProfile(named: userName)
//    }
//
//    func clearData() {
//        dataSource.clearData()
//    }
//
//    func tableViewDidSelectRow(at indexPath: IndexPath) {
//        let profiles = dataSource.profiles
//        guard indexPath.row < profiles.count else { fatalError() }
//        view?.showAccounts(of: profiles[indexPath.row])
//    }
    func addTask(from taskModel: TaskModel) {
        dataSource.addTask(from: taskModel)
    }
    
    func updateTask(from taskModel: TaskModel) {
        dataSource.updateTask(from: taskModel)
    }
}

extension TaskListViewModel: TaskListDataSourceObserver {
    func taskInserted(at newIndexPath: IndexPath) {
        view?.tableViewInsertRow(at: newIndexPath)
    }
    
    func taskDeleted(at indexPath: IndexPath) {
        view?.tableViewDeleteRow(at: indexPath)
    }
    
    func taskUpdated(at indexPath: IndexPath) {
        view?.tableViewBeginUpdates()
    }
    
    
}
