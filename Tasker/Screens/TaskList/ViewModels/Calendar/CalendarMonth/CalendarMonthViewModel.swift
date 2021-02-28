//
//  CalendarMonthViewModel.swift
//  Tasker
//
//  Created by KLuV on 17.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

class CalendarMonthViewModel: CalendarMonthViewModelType {
    var days: [CalendarDayViewModelType]
    var year: Int = 0
    var month: Int = 0
    
    init(with days: [CalendarDayViewModelType]) {
        self.days = days
        
        if let firstDayOfMonth = days.first(where: { $0.outputs.isWithinDisplayedMonth == true }) {
            let dateComponents = Calendar.current.taskCalendar.dateComponents([.month,.year], from: firstDayOfMonth.outputs.date)
            if let year = dateComponents.year, let month = dateComponents.month {
                self.year = year
                self.month = month
            }
        }
    }
}
