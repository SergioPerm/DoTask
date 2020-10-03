//
//  TaskModel.swift
//  Tasker
//
//  Created by kluv on 27/09/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import Foundation
import UIKit

struct TaskModel {
    var uid: String
    var title: String
    var taskDate: Date?
    var reminderDate: Bool
    var reminderGeo: Bool
    var lat: Double?
    var lon: Double?
    
    init() {
        self.uid = UUID().uuidString
        self.title = ""
        self.reminderGeo = false
        self.reminderDate = false
        self.taskDate = Date()
    }
    
    init(with task: Task) {
        self.uid = task.identificator.uuidString
        self.title = task.title!
        self.taskDate = task.taskDate
        self.reminderGeo = task.reminderGeo
        self.reminderDate = task.reminderDate
        self.lat = task.lat
        self.lon = task.lon
    }
    
}

