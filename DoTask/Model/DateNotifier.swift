//
//  NotifyByDateModel.swift
//  DoTask
//
//  Created by kluv on 05/10/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import Foundation
import UIKit

struct DateNotifier {
    var identifier: String
    var title: String
    var body: String
    var dateTrigger: DateComponents
        
    init(with taskModel: Task) {
        self.identifier = "calendar_\(taskModel.uid)"
        self.title = "New task!"
        self.body = taskModel.title
        self.dateTrigger = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: taskModel.taskDate ?? Date())
    }
}
