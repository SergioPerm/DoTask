//
//  DailyModel.swift
//  Tasker
//
//  Created by kluv on 28/09/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import Foundation

struct TaskTimePeriod {
    var name: String
    var tasks: [Task]
    var dailyName: DailyName? {
        didSet {
            guard let dailyName = dailyName else {
                return
            }
            name = dailyName.rawValue
        }
    }
    
    init() {
        self.name = ""
        self.tasks = []
    }
}
