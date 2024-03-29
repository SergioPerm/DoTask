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
        self.doneCounterEvent = Event<DoneCounter?>()
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
    
    func setDoneCounter(counter: DoneCounter) {
        self.doneCounter = counter
        self.doneCounterEvent.raise(counter)
    }
    
    // MARK: Outputs
    
    var title: String {
        return timePeriodName
    }
    
    var localizedTitle: LocalizableStringResource? {
        return taskListMode == .calendar ? nil : taskTimePeriod.localizedTitle
    }
    
    var date: Date? {
        return taskListMode == .calendar ? taskTimePeriod.date : nil
    }
    
    var titleHexColor: String {
        
        var hexColor = R.color.commonColors.blue()!.toHexString()
        
        switch taskTimePeriod.dailyName {
        case .today:
            hexColor = R.color.taskList.todayHeaderColor()!.toHexString()
        case .tommorow:
            hexColor = R.color.taskList.tomorrowHeaderColor()!.toHexString()
        case .currentWeek:
            hexColor = R.color.taskList.currentWeekHeaderColor()!.toHexString()
        case .later:
            hexColor = R.color.taskList.laterHeaderColor()!.toHexString()
        case .none:
            hexColor = R.color.commonColors.blue()!.toHexString()
        }
        
        return hexColor
        
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
    
    var doneCounter: DoneCounter?
    var doneCounterEvent: Event<DoneCounter?>
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
                
                if capMode != .LittleSpaceCap {
                    taskListItem.info = LocalizableStringResource(stringResource: R.string.localizable.cap_EMPTY_DAY)
                }
            }
            
            taskListEmptyItem = taskListItem
            tasks.append(taskListItem)
        }
        
    }
}
