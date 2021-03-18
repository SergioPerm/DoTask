//
//  TaskListDailyItemViewModel.swift
//  DoTask
//
//  Created by KLuV on 27.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

enum EmptyCapMode {
    case MainCap
    case CalendarCap
    case LittleSpaceCap
    
    func getRowHeight() -> Int {
        switch self {
        case .MainCap:
            return StyleGuide.TaskList.Sizes.capRowHeightMain
        case .CalendarCap:
            return StyleGuide.TaskList.Sizes.capRowHeightCalendar
        case .LittleSpaceCap:
            return StyleGuide.TaskList.Sizes.capRowHeightLittle
        }
    }
}

class TaskListPeriodItemViewModel: TaskListPeriodItemViewModelType, TaskListPeriodItemViewModelInputs, TaskListPeriodItemViewModelOutputs {
    
    private let timePeriodName: String
    private weak var taskListEmptyItem: TaskListEmptyItemViewModelType?
        
    private let taskTimePeriod: TaskTimePeriod
    
    var inputs: TaskListPeriodItemViewModelInputs { return self }
    var outputs: TaskListPeriodItemViewModelOutputs { return self }
    
    init(taskTimePeriod: TaskTimePeriod, taskListMode: TaskListMode = .list) {
        self.taskTimePeriod = taskTimePeriod
        self.timePeriodName = taskTimePeriod.name
        self.taskListMode = taskListMode
    }
    
    // MARK: Inputs
    
    func setShowingCapWhenTasksIsEmpty(emptyState: Bool, capMode: EmptyCapMode?) {
        self.showingCapWhenTasksIsEmpty = true
        self.capMode = capMode
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
        
        if tasks.isEmpty {
            updateEmptyState(emptyState: true)
        }
    }
    
    func setTaskListMode(mode: TaskListMode) {
        taskListMode = mode
    }
    
    // MARK: Outputs
    
    var title: String {
        return timePeriodName
    }
    
    var tasks: [TaskListItemType] = []
    
    var taskListMode: TaskListMode
    
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
    var capMode: EmptyCapMode?
    
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
            
            if let capMode = capMode {
                taskListItem.rowHeight = capMode.getRowHeight()
                
                if capMode == .LittleSpaceCap {
                    taskListItem.info = ""
                } else {
                    taskListItem.info = "The day is empty"
                }
            }
            
            taskListEmptyItem = taskListItem
            tasks.append(taskListItem)
        }
        
    }
}
