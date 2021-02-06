//
//  TaskDiaryPeriodItemViewModel.swift
//  Tasker
//
//  Created by KLuV on 04.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

class TaskDiaryPeriodItemViewModel: TaskDiaryPeriodItemViewModelType {
    
    private let timePeriodName: String
    
    var tasks: [TaskDiaryItemViewModelType] = []
        
    init(taskTimePeriod: TaskTimePeriod) {
        self.timePeriodName = taskTimePeriod.name
    }
    
    // MARK: Outputs
    
    var title: String {
        return timePeriodName
    }
    
}
