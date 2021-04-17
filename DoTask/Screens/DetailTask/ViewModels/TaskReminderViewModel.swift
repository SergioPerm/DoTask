//
//  TaskReminderInfoViewModel.swift
//  DoTask
//
//  Created by KLuV on 01.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

class TaskReminderViewModel: DetailTaskTableItemViewModelType, TaskReminderViewModelType, TaskReminderViewModelInputs, TaskReminderViewModelOutputs {
    
    private let openReminderHandler: () -> Void
        
    var inputs: TaskReminderViewModelInputs { return self }
    var outputs: TaskReminderViewModelOutputs { return self }
    
    init(taskTime: Date?, openReminderHandler: @escaping () -> Void) {
        self.openReminderHandler = openReminderHandler
        
        if let taskTime = taskTime {
            self.timeInfo = Observable(taskTime)
        } else {
            self.timeInfo = Observable(nil)
        }
    }
    
    // MARK: Inputs
    
    func setTime(time: Date?) {
        if let taskTime = time {
            timeInfo.value = taskTime
        } else {
            timeInfo.value = nil
        }
    }
    
    func openReminder() {
        openReminderHandler()
    }
    
    // MARK: Outputs
    
    var timeInfo: Observable<Date?>
    
}
