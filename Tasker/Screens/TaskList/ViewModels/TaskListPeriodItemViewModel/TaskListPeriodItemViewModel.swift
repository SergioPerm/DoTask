//
//  TaskListDailyItemViewModel.swift
//  Tasker
//
//  Created by KLuV on 27.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

class TaskListPeriodItemViewModel: TaskListPeriodItemViewModelType {
    
    private let timePeriodName: String
    
    var tasks: [TaskListItemViewModelType] = []
        
    init(taskTimePeriod: TaskTimePeriod) {
        self.timePeriodName = taskTimePeriod.name
    }
    
    // MARK: Outputs
    
    var title: String {
        return timePeriodName
    }
    
}
