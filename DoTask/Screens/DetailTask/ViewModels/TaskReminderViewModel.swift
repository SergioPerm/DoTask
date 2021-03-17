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
    
    private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }()
    
    var inputs: TaskReminderViewModelInputs { return self }
    var outputs: TaskReminderViewModelOutputs { return self }
    
    init(taskTime: Date?, openReminderHandler: @escaping () -> Void) {
        self.openReminderHandler = openReminderHandler
        
        if let taskTime = taskTime {
            self.timeInfo = Observable(dateFormatter.string(from: taskTime))
        } else {
            self.timeInfo = Observable(nil)
        }
    }
    
    // MARK: Inputs
    
    func setTime(time: Date?) {
        if let taskTime = time {
            timeInfo.value = dateFormatter.string(from: taskTime)
        } else {
            timeInfo.value = nil
        }
    }
    
    func openReminder() {
        openReminderHandler()
    }
    
    // MARK: Outputs
    
    var timeInfo: Observable<String?>
    
}