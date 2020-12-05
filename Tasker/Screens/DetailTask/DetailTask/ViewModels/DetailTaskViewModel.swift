//
//  DetailTaskViewModel.swift
//  Tasker
//
//  Created by kluv on 21/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import Foundation

class DetailTaskViewModel: DetailTaskViewModelType, DetailTaskViewModelInputs, DetailTaskViewModelOutputs {
    
    private var taskModel: TaskModel
    private var dataSource: TaskListDataSource
    
    var inputs: DetailTaskViewModelInputs { return self }
    var outputs: DetailTaskViewModelOutputs { return self }
    
    init(taskUID: String?, dataSource: TaskListDataSource) {
        self.taskModel = dataSource.taskModelByIdentifier(identifier: taskUID) ?? TaskModel()
        self.dataSource = dataSource
        
        self.selectedDate = Boxing(taskModel.taskDate)
        self.selectedTime = Boxing(taskModel.reminderDate ? taskModel.taskDate : nil)
        self.importanceLevel = Int(taskModel.importanceLevel)
    }
    
    // MARK: INPUTS
    
    func setTaskDate(date: Date?) {
        taskModel.taskDate = date
        selectedDate.value = date
    }
    
    func setReminder(date: Date?) {
        if let date = date {
            taskModel.reminderDate = true
            taskModel.taskDate = date
        } else {
            taskModel.reminderDate = false
        }
        selectedTime.value = date
    }
    
    func setTitle(title: String) {
        taskModel.title = title
    }
    
    func increaseImportance() {
        taskModel.importanceLevel += 1
        importanceLevel = Int(taskModel.importanceLevel)
    }
    
    func saveTask() {
        if taskModel.isNew {
            dataSource.addTask(from: taskModel)
        } else {
            dataSource.updateTask(from: taskModel)
        }
    }
    
    // MARK: OUTPUTS
    
    var selectedDate: Boxing<Date?>
    var selectedTime: Boxing<Date?>
    var importanceLevel: Int
    
    var title: String {
        return taskModel.title
    }

}
