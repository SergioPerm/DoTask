//
//  TaskListDailyItemViewModel.swift
//  Tasker
//
//  Created by KLuV on 27.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

class TaskListPeriodItemViewModel: TaskListPeriodItemViewModelType, TaskListPeriodItemViewModelInputs, TaskListPeriodItemViewModelOutputs {
    
    private let timePeriodName: String
    private weak var taskListEmptyItem: TaskListEmptyItemViewModelType?
        
    private let taskTimePeriod: TaskTimePeriod
    
    var inputs: TaskListPeriodItemViewModelInputs { return self }
    var outputs: TaskListPeriodItemViewModelOutputs { return self }
    
    init(taskTimePeriod: TaskTimePeriod, taskListMode: TaskListMode = .list) {
        self.taskTimePeriod = taskTimePeriod
        self.timePeriodName = taskTimePeriod.name
        self.taskListMode = Boxing(taskListMode)
    }
    
    // MARK: Inputs
    
    func setShowingCapWhenTasksIsEmpty(emptyState: Bool) {
        showingCapWhenTasksIsEmpty = true
        updateEmptyState(emptyState: emptyState)
    }
        
    func insert(task: TaskListItemViewModelType, at index: Int) {
        tasks.insert(task, at: index)
        
        if let _ = taskListEmptyItem {
            updateEmptyState(emptyState: false)
        }
    }
    
    func insert(task: TaskListItemViewModelType) {
        tasks.append(task)
        
        if let _ = taskListEmptyItem {
            updateEmptyState(emptyState: false)
        }
    }
    
    func remove(at index: Int) {
        tasks.remove(at: index)
        
        if tasks.count == 0 {
            updateEmptyState(emptyState: true)
        }
    }
    
    func setTaskListMode(mode: TaskListMode) {
        taskListMode.value = mode
    }
    
    // MARK: Outputs
    
    var title: String {
        return timePeriodName
    }
    
    var tasks: [TaskListItemType] = []
    
    var taskListMode: Boxing<TaskListMode>
    
    var isEmpty: Bool {
        
        if let _ = taskListEmptyItem {
            return true
        }
        
        if tasks.isEmpty {
            return true
        }
        
        return false

    }
    
    var showingCapWhenTasksIsEmpty: Bool = false
    
    var dailyName: DailyName? {
        if let dailyName = taskTimePeriod.dailyName {
            return dailyName
        }
        
        return nil
    }
}

extension TaskListPeriodItemViewModel {
    private func updateEmptyState(emptyState: Bool) {
        
        if let _ = taskListEmptyItem {
            tasks.removeAll(where: {
                if let _ = $0 as? TaskListEmptyItemViewModelType {
                    return true
                }
                return false
            })
        }
        
        if emptyState && showingCapWhenTasksIsEmpty {
            let taskListItem = TaskListEmptyItemViewModel()
            
            taskListEmptyItem = taskListItem
            tasks.append(taskListItem)
        }
        
    }
}
