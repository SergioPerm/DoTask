//
//  TaskListItemViewModel.swift
//  DoTask
//
//  Created by KLuV on 27.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

class TaskListItemViewModel: TaskListItemViewModelType, TaskListItemViewModelInputs, TaskListItemViewModelOutputs {

    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        return dateFormatter
    }()
    
    private let timeFormatter: DateFormatter = {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        return timeFormatter
    }()
    
    private var task: Task
    private var taskUID: String
    
    var inputs: TaskListItemViewModelInputs { return self }
    var outputs: TaskListItemViewModelOutputs { return self }

    private let changeDoneTaskHandler: ((_ taskUID: String, _ done: Bool) -> Void)
    
    init(task: Task, setDoneTaskHandler: @escaping ((_ taskUID: String, _ done: Bool) -> Void)) {
        self.task = task
        self.title = Observable(task.title)
        
        if let taskDate = task.taskDate {
            self.date = Observable(dateFormatter.string(from: taskDate))
            self.reminderTime = Observable(task.reminderDate ? timeFormatter.string(from: taskDate) : "")
        } else {
            self.date = Observable("")
            self.reminderTime = Observable("")
        }
        
        self.importantColor = Observable("")
        
        if let shortcut = task.shortcut {
            self.shortcutColor = Observable(shortcut.color)
        } else {
            self.shortcutColor = Observable(nil)
        }
        
        self.isDone = Observable(task.isDone)
        
        self.taskUID = task.uid
        self.changeDoneTaskHandler = setDoneTaskHandler
        
        self.importantColor.value = getHexImportanceColor(importanceLevel: task.importanceLevel)
        
    }
    
    func reuse(task: Task) {
        self.task = task
        taskUID = task.uid
        
        title.value = task.title
        
        if let taskDate = task.taskDate {
            date.value = dateFormatter.string(from: taskDate)
            reminderTime.value = task.reminderDate ? timeFormatter.string(from: taskDate) : ""
        } else {
            date.value = ""
            reminderTime.value = ""
        }
        
        if let shortcut = task.shortcut {
            self.shortcutColor.value = shortcut.color
        } else {
            self.shortcutColor.value = nil
        }
        
        self.importantColor.value = getHexImportanceColor(importanceLevel: task.importanceLevel)
    }
    
    // MARK: Inputs
    
    func setDone() {
        isDone.value = true
        changeDoneTaskHandler(taskUID, true)
    }
    
    func unsetDone() {
        isDone.value = false
        changeDoneTaskHandler(taskUID, false)
    }
    
    // MARK: Outputs
    
    var title: Observable<String>
    var date: Observable<String>
    var reminderTime: Observable<String?>
    var importantColor: Observable<String?>
    var shortcutColor: Observable<String?>
    var isDone: Observable<Bool>
    
    func getTaskUID() -> String {
        return taskUID
    }
    
    var overDue: Bool {
        if let taskDate = task.taskDate {
            return taskDate < Date().startOfDay()
        } else {
            return false
        }
    }
    
}

extension TaskListItemViewModel {
    private func getHexImportanceColor(importanceLevel: Int16) -> String? {
        let importanceLevel = ImportanceLevel(rawValue: Int(importanceLevel)) ?? .noImportant
        
        switch importanceLevel {
        case .noImportant:
            return nil
        case .important:
            return "D4FFD7"
        case .veryImportant:
            return "FFF7CB"
        case .fuckedUpImportant:
            return "FFDDD9"
        }
    }
}
