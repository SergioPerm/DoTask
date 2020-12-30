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
        
    var subtasks: [SubtaskViewModelType] = []
    
    var inputs: DetailTaskViewModelInputs { return self }
    var outputs: DetailTaskViewModelOutputs { return self }
    
    init(taskUID: String?, dataSource: TaskListDataSource) {
                
        self.task = dataSource.taskModelByIdentifier(identifier: taskUID) ?? Task()
        self.dataSource = dataSource
        
        self.selectedDate = Boxing(task.taskDate)
        self.selectedTime = Boxing(task.reminderDate ? task.taskDate : nil)
        self.importanceLevel = Int(task.importanceLevel)
        
        self.subtasks = self.task.subtasks.map {
            return SubtaskViewModel(subtask: $0)
        }
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
  
    func addSubtask() -> Int {
        let newSubtask = SubtaskViewModel(subtask: Subtask())
        
        subtasks.append(newSubtask)
        return subtasks.count - 1
    }
    
    func deleteSubtask(subtask: SubtaskViewModelType) {
        if let removeIndex = subtasks.firstIndex(where: { $0 == subtask }) {
            subtasks.remove(at: removeIndex)
        }
    }
        
    func moveSubtask(from: Int, to: Int) {
        subtasks.insert(subtasks.remove(at: from), at: to)
    }
    
    func saveTask() {
        var priority: Int16 = 0
        task.subtasks = subtasks.map {
            var subtask = Subtask()
            subtask.isDone = $0.outputs.isDone
            subtask.title = $0.outputs.title
            subtask.priority = priority
            
            priority += 1
            
            return subtask
        }
        
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
}
