//
//  TaskReminderInfoViewModel.swift
//  Tasker
//
//  Created by KLuV on 01.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

class TaskReminderInfoViewModel: DetailTaskTableItemViewModelType, TaskReminderInfoViewModelType, TaskReminderInfoViewModelInputs, TaskReminderInfoViewModelOutputs {
    
    private let openReminderHandler: () -> Void
    
    private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }()
    
    var inputs: TaskReminderInfoViewModelInputs { return self }
    var outputs: TaskReminderInfoViewModelOutputs { return self }
    
    init(taskTime: Date?, openReminderHandler: @escaping () -> Void) {
        self.openReminderHandler = openReminderHandler
        
        if let taskTime = taskTime {
            self.timeInfo = Boxing(dateFormatter.string(from: taskTime))
        } else {
            self.timeInfo = Boxing("Set reminder")
        }
    }
    
    // MARK: Inputs
    
    func setTime(time: Date?) {
        if let taskTime = time {
            timeInfo.value = dateFormatter.string(from: taskTime)
        } else {
            timeInfo.value = "Set reminder"
        }
    }
    
    func openReminder() {
        openReminderHandler()
    }
    
    // MARK: Outputs
    
    var timeInfo: Boxing<String?>
    
}
