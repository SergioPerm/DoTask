//
//  TaskListViewModel.swift
//  Tasker
//
//  Created by KLuV on 27.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

struct TaskListFilter {
    let shortcutFilter: String?
    let taskDiaryMode: Bool
}

class TaskListViewModel: TaskListViewModelType, TaskListViewModelInputs, TaskListViewModelOutputs {

    private var dataSource: TaskListDataSource
        
    weak var view: TaskListView?
    
    var inputs: TaskListViewModelInputs { return self }
    var outputs: TaskListViewModelOutputs { return self }
    
    private var tableViewFRCHelper: TableViewFRCHelper = TableViewFRCHelper()
    
    init(dataSource: TaskListDataSource) {
        self.dataSource = dataSource
        self.shortcutFilter = Boxing(nil)
        self.taskDiaryMode = Boxing(false)
        self.periodItems = []
                
        self.dataSource.observer = self
        
        //dataSource.clearData()
        tableViewFRCHelper.delegate = self
        loadData()
        PushNotificationService.shared.attachObserver(self)
    }
    
    // MARK: Inputs
        
    func setFilter(filter: TaskListFilter) {
        dataSource.applyFilters(filter: filter)
        loadData()
        
        if let shortcutUID = filter.shortcutFilter {
            let shortcut = dataSource.shortcutModelByIdentifier(identifier: shortcutUID)
            shortcutFilter.value = (title: shortcut?.name, colorHex: shortcut?.color)
        } else {
            shortcutFilter.value = nil
        }
        
        if filter.taskDiaryMode {
            taskDiaryMode.value = true
        }
    }
    
    func editTask(indexPath: IndexPath) {
        let itemViewModel = periodItems[indexPath.section].tasks[indexPath.row]
        let taskUID = itemViewModel.outputs.getTaskUID()
        view?.editTask(taskUID: taskUID)
    }
    
    // MARK: Outputs
    
    var periodItems: [TaskListPeriodItemViewModelType]
    var shortcutFilter: Boxing<ShortcutData?>
    var taskDiaryMode: Boxing<Bool>
    
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
            
    private func updateTaskInData(indexPath: IndexPath) {
        let task = dataSource.tasksWithSections[indexPath.section].tasks[indexPath.row]
        periodItems[indexPath.section].tasks[indexPath.row].inputs.reuse(task: task)
    }
}

extension TaskListViewModel: TableViewFRCHelperDelegate {
    func deleteItem(indexPath: IndexPath) {
        periodItems[indexPath.section].tasks.remove(at: indexPath.row)
        if periodItems[indexPath.section].tasks.count == 0 {
            periodItems.remove(at: indexPath.section)
        }
    }
    
    func addSection(indexPath: IndexPath) {
        let section = indexPath.section
        
        let timePeriod = dataSource.tasksWithSections[section]
        periodItems.insert(TaskListPeriodItemViewModel(taskTimePeriod: timePeriod), at: section)
    }
    
    func addItem(indexPath: IndexPath) {
        let task = dataSource.tasksWithSections[indexPath.section].tasks[indexPath.row]
        periodItems[indexPath.section].tasks.insert(TaskListItemViewModel(task: task, setDoneTaskHandler: setDoneTask(taskUID:)), at: indexPath.row)
    }
}

extension TaskListViewModel: TaskListDataSourceObserver {
    func tasksWillChange() {
        view?.tableViewBeginUpdates()
    }
    
    func tasksDidChange() {
        tableViewFRCHelper.applyChanges()
        view?.tableViewEndUpdates()
    }
    
    func taskInserted(at newIndexPath: IndexPath) {
        tableViewFRCHelper.addTableChange(changeType: .insertItem, indexPath: newIndexPath)
        view?.tableViewInsertRow(at: newIndexPath)
    }
    
    func taskDeleted(at indexPath: IndexPath) {
        tableViewFRCHelper.addTableChange(changeType: .deleteItem, indexPath: indexPath)
        view?.tableViewDeleteRow(at: indexPath)
    }
    
    func taskUpdated(at indexPath: IndexPath) {
        updateTaskInData(indexPath: indexPath)
    }
    
    func taskSectionDelete(section: Int) {
        view?.tableViewSectionDelete(at: IndexSet(integer: section))
    }
    
    func taskSectionInsert(section: Int) {
        tableViewFRCHelper.addTableChange(changeType: .insertSection, indexPath: IndexPath(row: 0, section: section))
        view?.tableViewSectionInsert(at: IndexSet(integer: section))
    }
}

// MARK: NotificationTaskObserver

extension TaskListViewModel: NotificationTaskObserver {
    func onTapNotification(with id: String) {
        view?.editTask(taskUID: id)
    }
}

