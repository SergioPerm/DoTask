//
//  TaskDateInfoViewModel.swift
//  DoTask
//
//  Created by KLuV on 31.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

class TaskDateViewModel: DetailTaskTableItemViewModelType, TaskDateViewModelType, TaskDateViewModelInputs, TaskDateViewModelOutputs {

    private let openCalendarHandler: () -> Void
        
    var inputs: TaskDateViewModelInputs { return self }
    var outputs: TaskDateViewModelOutputs { return self }
    
    init(taskDate: Date?, openCalendarHandler: @escaping () -> Void) {
        self.openCalendarHandler = openCalendarHandler
        
        if let taskDate = taskDate {
            self.dateInfo = Observable(taskDate)
        } else {
            self.dateInfo = Observable(nil)
        }
    }
    
    // MARK: Inputs
    
    func openCalendar() {
        openCalendarHandler()
    }
        
    func setDate(date: Date?) {
        
        if let taskDate = date {
            dateInfo.value = taskDate//dateFormatter.string(from: taskDate)
        } else {
            dateInfo.value = nil
        }
    }
    
    // MARK: Outputs
    
    var dateInfo: Observable<Date?>
    
}
