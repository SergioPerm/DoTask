//
//  Subtask.swift
//  DoTask
//
//  Created by KLuV on 22.12.2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import Foundation

struct Subtask {
    var isDone: Bool
    var title: String
    var priority: Int16
    
    init(with priority: Int16 = 0) {
        self.isDone = false
        self.title = ""
        self.priority = priority
    }
    
    init(with subtask: SubtaskManaged) {
        self.isDone = subtask.isDone
        self.title = subtask.title
        self.priority = subtask.priority
    }
}
