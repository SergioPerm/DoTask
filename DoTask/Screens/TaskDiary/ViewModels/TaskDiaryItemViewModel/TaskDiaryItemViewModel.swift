//
//  TaskDiaryItemViewModel.swift
//  DoTask
//
//  Created by KLuV on 04.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

class TaskDiaryItemViewModel: TaskDiaryItemViewModelType, TaskDiaryItemViewModelInputs, TaskDiaryItemViewModelOutputs {
    
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
    
    private let unsetDoneTaskHandler: (_ taskUID: String) -> Void
    
    var inputs: TaskDiaryItemViewModelInputs { return self }
    var outputs: TaskDiaryItemViewModelOutputs { return self }
    
    init(task: Task, unsetDoneTaskHandler: @escaping ((_ taskUID: String) -> Void)) {
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
                
        self.taskUID = task.uid
        self.unsetDoneTaskHandler = unsetDoneTaskHandler
        
        self.importantColor.value = getHexImportanceColor(importanceLevel: task.importanceLevel)
        
    }
    
    // MARK: Inputs
    
    func unsetDone() {
        unsetDoneTaskHandler(taskUID)
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
    
    // MARK: Outputs
    
    var title: Observable<String>
    
    var date: Observable<String>
    
    var reminderTime: Observable<String?>
    
    var importantColor: Observable<String?>
    
    var shortcutColor: Observable<String?>
    
    func getTaskUID() -> String {
        return taskUID
    }
    
}

extension TaskDiaryItemViewModel {
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
