//
//  TaskListItemViewModel.swift
//  Tasker
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
    
    private var taskUID: String
    
    var inputs: TaskListItemViewModelInputs { return self }
    var outputs: TaskListItemViewModelOutputs { return self }

    private let setDoneTaskHandler: ((_ taskUID: String) -> Void)
    
    init(task: Task, setDoneTaskHandler: @escaping ((_ taskUID: String) -> Void)) {
        self.title = Boxing(task.title)
        
        if let taskDate = task.taskDate {
            self.date = Boxing(dateFormatter.string(from: taskDate))
            self.reminderTime = Boxing(task.reminderDate ? timeFormatter.string(from: taskDate) : "")
        } else {
            self.date = Boxing("")
            self.reminderTime = Boxing("")
        }
        
        self.importantColor = Boxing("")
        
        if let shortcut = task.shortcut {
            self.shortcutColor = Boxing(shortcut.color)
        } else {
            self.shortcutColor = Boxing(nil)
        }
        
        self.isDone = Boxing(task.isDone)
        
        self.taskUID = task.uid
        self.setDoneTaskHandler = setDoneTaskHandler
        
        self.importantColor.value = getHexImportanceColor(importanceLevel: task.importanceLevel)
        
    }
    
    func reuse(task: Task) {
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
        setDoneTaskHandler(taskUID)
    }
    
    // MARK: Outputs
    
    var title: Boxing<String>
    var date: Boxing<String>
    var reminderTime: Boxing<String?>
    var importantColor: Boxing<String?>
    var shortcutColor: Boxing<String?>
    var isDone: Boxing<Bool>
    
    func getTaskUID() -> String {
        return taskUID
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
