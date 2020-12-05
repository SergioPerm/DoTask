//
//  DailyModel.swift
//  Tasker
//
//  Created by kluv on 28/09/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import Foundation

struct Daily {
    var dailyName: String?
    var tasks: [TaskModel]
    
    init() {
        self.dailyName = ""
        self.tasks = []
    }
}
