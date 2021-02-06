//
//  TaskModel.swift
//  Tasker
//
//  Created by kluv on 27/09/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import Foundation
import UIKit

struct Task {
    var uid: String
    var title: String
    var taskDate: Date?
    var reminderDate: Bool
    var reminderGeo: Bool
    var lat: Double?
    var lon: Double?
    var isNew: Bool = false
    var isDone: Bool
    
    var importanceLevel: Int16 {
        didSet {
            if importanceLevel > 3 {
                importanceLevel = 0
            }
        }
    }
    
    var mainTaskListOrder: Int16
    var subtasks: [Subtask]
    var shortcut: Shortcut?
    
    init() {
        self.uid = UUID().uuidString
        self.title = ""
        self.reminderGeo = false
        self.reminderDate = false
        self.taskDate = Date()
        self.isNew = true
        self.importanceLevel = 0
        self.mainTaskListOrder = self.taskDate == nil ? 1 : 0
        self.subtasks = []
        self.isDone = false
    }
    
    init(with task: TaskManaged) {
        self.uid = task.identificator.uuidString
        self.title = task.title!
        self.taskDate = task.taskDate
        self.reminderGeo = task.reminderGeo
        self.reminderDate = task.reminderDate
        self.lat = task.lat
        self.lon = task.lon
        self.importanceLevel = task.importanceLevel
        self.mainTaskListOrder = task.mainTaskListOrder
        self.isDone = task.isDone
        
        let subtasksManaged = task.subtasks.allObjects as! [SubtaskManaged]
                
        self.subtasks = subtasksManaged.map {
            return Subtask(with: $0)
        }.sorted {
            $0.priority < $1.priority
        }
        
        if let shortcutManaged = task.shortcut {
            self.shortcut = Shortcut(with: shortcutManaged)
        }
    }
}

