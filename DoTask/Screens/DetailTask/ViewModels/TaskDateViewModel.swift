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
    
    private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter
    }()
    
    var inputs: TaskDateViewModelInputs { return self }
    var outputs: TaskDateViewModelOutputs { return self }
    
    init(taskDate: Date?, openCalendarHandler: @escaping () -> Void) {
        self.openCalendarHandler = openCalendarHandler
        
        if let taskDate = taskDate {
            self.dateInfo = Boxing(dateFormatter.string(from: taskDate))
        } else {
            self.dateInfo = Boxing(nil)
        }
    }
    
    // MARK: Inputs
    
    func openCalendar() {
        openCalendarHandler()
    }
        
    func setDate(date: Date?) {
        
        if let taskDate = date {
            dateInfo.value = dateFormatter.string(from: taskDate)
        } else {
            dateInfo.value = nil
        }
    }
    
    // MARK: Outputs
    
    var dateInfo: Boxing<String?>
    
}
