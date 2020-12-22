//
//  DetailTaskViewModel.swift
//  Tasker
//
//  Created by kluv on 21/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import Foundation

class DetailTaskViewModel: DetailTaskViewModelType, DetailTaskViewModelInputs, DetailTaskViewModelOutputs {
      
    private var task: Task
    private var dataSource: TaskListDataSource
    
    var inputs: DetailTaskViewModelInputs { return self }
    var outputs: DetailTaskViewModelOutputs { return self }
    
    init(taskUID: String?, dataSource: TaskListDataSource) {
        self.task = dataSource.taskModelByIdentifier(identifier: taskUID) ?? Task()
        self.dataSource = dataSource
        
        self.selectedDate = Boxing(task.taskDate)
        self.selectedTime = Boxing(task.reminderDate ? task.taskDate : nil)
        self.importanceLevel = Int(task.importanceLevel)
    }
    
    // MARK: INPUTS
    
    func setTaskDate(date: Date?) {
        task.taskDate = date
        selectedDate.value = date
    }
    
    func setReminder(date: Date?) {
        if let date = date {
            task.reminderDate = true
            task.taskDate = date
        } else {
            task.reminderDate = false
        }
        selectedTime.value = date
    }
    
    func setTitle(title: String) {
        task.title = title
    }
    
    func increaseImportance() {
        task.importanceLevel += 1
        importanceLevel = Int(task.importanceLevel)
    }
    
    func changeSubtasks(subtasks: [SubtaskViewModelType]) {
        task.subtasks.removeAll()
        subtasks.forEach {
            var subtask = Subtask()
            subtask.isDone = $0.outputs.isDone
            subtask.title = $0.outputs.title
            subtask.priority = $0.outputs.priority
            
            task.subtasks.append(subtask)
        }
    }
    
    func saveTask() {
        if task.isNew {
            dataSource.addTask(from: task)
        } else {
            dataSource.updateTask(from: task)
        }
    }
    
    // MARK: OUTPUTS
    
    var selectedDate: Boxing<Date?>
    var selectedTime: Boxing<Date?>
    var importanceLevel: Int
    
    var title: String {
        return task.title
    }
    
    var subtasks: [SubtaskViewModelType] {
        return task.subtasks.map {
            return SubtaskViewModel(subtask: $0, detailTaskViewModel: self)
        }
    }

}
