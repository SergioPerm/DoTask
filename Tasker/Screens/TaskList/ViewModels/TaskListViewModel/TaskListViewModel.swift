//
//  TaskListViewModel.swift
//  Tasker
//
//  Created by KLuV on 27.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

class TaskListViewModel: TaskListViewModelType, TaskListViewModelInputs, TaskListViewModelOutputs {

    private var dataSource: TaskListDataSource
        
    weak var view: TaskListView?
    
    var inputs: TaskListViewModelInputs { return self }
    var outputs: TaskListViewModelOutputs { return self }
    
    init(dataSource: TaskListDataSource) {
        self.dataSource = dataSource
        self.shortcutFilter = Boxing(nil)
        self.periodItems = []
                
        self.dataSource.observer = self
        
        loadData()
        PushNotificationService.shared.attachObserver(self)
    }
    
    // MARK: Inputs
    
    func setShortcutFilter(shortcutUID: String?) {
        guard let shortcutUID = shortcutUID else {
            dataSource.applyShortcutFilter(shortcutFilter: nil)
            loadData()
            shortcutFilter.value = nil
            return
        }
        
        let shortcut = dataSource.shortcutModelByIdentifier(identifier: shortcutUID)
        dataSource.applyShortcutFilter(shortcutFilter: shortcutUID)
        loadData()
        shortcutFilter.value = (title: shortcut?.name, colorHex: shortcut?.color)
    }
    
    func editTask(indexPath: IndexPath) {
        let itemViewModel = periodItems[indexPath.section].tasks[indexPath.row]
        let taskUID = itemViewModel.outputs.getTaskUID()
        view?.editTask(taskUID: taskUID)
    }
    
    // MARK: Outputs
    
    var periodItems: [TaskListPeriodItemViewModelType]
    var shortcutFilter: Boxing<ShortcutData?>
    
}

extension TaskListViewModel {
    private func setDoneTask(taskUID: String) {
        dataSource.setDoneForTask(with: taskUID)
    }
    
    private func loadData() {
        
        periodItems.removeAll()
        dataSource.tasksWithSections.forEach { timePeriod in
            let periodItem = TaskListPeriodItemViewModel(taskTimePeriod: timePeriod)
            
            timePeriod.tasks.forEach { task in
                periodItem.tasks.append(TaskListItemViewModel(task: task, setDoneTaskHandler: setDoneTask(taskUID:)))
            }
            
            periodItems.append(periodItem)
        }

    }
    
    private func addTaskInData(indexPath: IndexPath) {
        let task = dataSource.tasksWithSections[indexPath.section].tasks[indexPath.row]
        periodItems[indexPath.section].tasks.insert(TaskListItemViewModel(task: task, setDoneTaskHandler: setDoneTask(taskUID:)), at: indexPath.row)
    }
    
    private func deleteTaskInData(indexPath: IndexPath) {
        periodItems[indexPath.section].tasks.remove(at: indexPath.row)
    }
    
    private func addTimePeriodInData(indexSet: IndexSet) {
        if let section = indexSet.first {
            let timePeriod = dataSource.tasksWithSections[section]
            periodItems.insert(TaskListPeriodItemViewModel(taskTimePeriod: timePeriod), at: section)
        }
    }
    
    private func deleteTimePeriodInData(indexSet: IndexSet) {
        if let section = indexSet.first {
            periodItems.remove(at: section)
        }
    }
    
    private func updateTaskInData(indexPath: IndexPath) {
        let task = dataSource.tasksWithSections[indexPath.section].tasks[indexPath.row]
        periodItems[indexPath.section].tasks[indexPath.row].inputs.reuse(task: task)
    }
}

extension TaskListViewModel: TaskListDataSourceObserver {
    func tasksWillChange() {
        view?.tableViewBeginUpdates()
    }
    
    func tasksDidChange() {
        view?.tableViewEndUpdates()
    }
    
    func taskInserted(at newIndexPath: IndexPath) {
        addTaskInData(indexPath: newIndexPath)
        view?.tableViewInsertRow(at: newIndexPath)
    }
    
    func taskDeleted(at indexPath: IndexPath) {
        deleteTaskInData(indexPath: indexPath)
        view?.tableViewDeleteRow(at: indexPath)
    }
    
    func taskUpdated(at indexPath: IndexPath) {
        updateTaskInData(indexPath: indexPath)
    }
    
    func taskSectionDelete(indexSet: IndexSet) {
        deleteTimePeriodInData(indexSet: indexSet)
        view?.tableViewSectionDelete(at: indexSet)
    }
    
    func taskSectionInsert(indexSet: IndexSet) {
        addTimePeriodInData(indexSet: indexSet)
        view?.tableViewSectionInsert(at: indexSet)
    }
}

// MARK: NotificationTaskObserver

extension TaskListViewModel: NotificationTaskObserver {
    func onTapNotification(with id: String) {
        view?.editTask(taskUID: id)
    }
}

