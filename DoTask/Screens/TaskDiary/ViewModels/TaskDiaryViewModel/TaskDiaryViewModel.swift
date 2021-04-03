//
//  TaskDiaryViewModel.swift
//  DoTask
//
//  Created by KLuV on 04.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

class TaskDiaryViewModel: TaskDiaryViewModelType, TaskDiaryViewModelInputs, TaskDiaryViewModelOutputs {
    
    private var dataSource: TaskListDataSource
    private var tableViewFRCHelper: TableViewFRCHelper = TableViewFRCHelper()
    
    var inputs: TaskDiaryViewModelInputs { return self }
    var outputs: TaskDiaryViewModelOutputs { return self }

    weak var view: TaskDiaryViewType?
    
    init(dataSource: TaskListDataSource) {
        self.dataSource = dataSource
        self.periodItems = []
                
        self.dataSource.observer = self
        
        dataSource.setOnlyDoneTasksMode()
        
        tableViewFRCHelper.delegate = self
        loadData()
    }

    // MARK: Inputs

    func editTask(indexPath: IndexPath) {
        let itemViewModel = periodItems[indexPath.section].tasks[indexPath.row]
        let taskUID = itemViewModel.outputs.getTaskUID()
        view?.editTask(taskUID: taskUID)
    }

    // MARK: Outputs

    var periodItems: [TaskDiaryPeriodItemViewModelType]

}

extension TaskDiaryViewModel {
    private func unsetDoneTask(taskUID: String) {
        dataSource.unsetDoneForTask(with: taskUID)
    }
    
    private func loadData() {
        
        periodItems.removeAll()
        dataSource.tasksWithSections.forEach { timePeriod in
            let periodItem = TaskDiaryPeriodItemViewModel(taskTimePeriod: timePeriod)
            
            timePeriod.tasks.forEach { task in
                periodItem.tasks.append(TaskDiaryItemViewModel(task: task) { [weak self] taskUID in
                    self?.unsetDoneTask(taskUID: taskUID)
                })
            }
            
            periodItems.append(periodItem)
        }
    }
    
    private func updateTaskInData(indexPath: IndexPath) {
        let task = dataSource.tasksWithSections[indexPath.section].tasks[indexPath.row]
        periodItems[indexPath.section].tasks[indexPath.row].inputs.reuse(task: task)
    }
    
}

extension TaskDiaryViewModel: TableViewFRCHelperDelegate {
    func deleteItem(indexPath: IndexPath) {
        periodItems[indexPath.section].tasks.remove(at: indexPath.row)
        if periodItems[indexPath.section].tasks.isEmpty {
            periodItems.remove(at: indexPath.section)
        }
    }
    
    func addSection(indexPath: IndexPath) {
        let section = indexPath.section
        
        let timePeriod = dataSource.tasksWithSections[section]
        periodItems.insert(TaskDiaryPeriodItemViewModel(taskTimePeriod: timePeriod), at: section)
    }
    
    func addItem(indexPath: IndexPath) {
        let task = dataSource.tasksWithSections[indexPath.section].tasks[indexPath.row]
        periodItems[indexPath.section].tasks.insert(TaskDiaryItemViewModel(task: task, unsetDoneTaskHandler: unsetDoneTask(taskUID:)), at: indexPath.row)
    }
    
    func deleteSection(indexPath: IndexPath) {
        
    }
}

extension TaskDiaryViewModel: TaskListDataSourceObserver {
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
