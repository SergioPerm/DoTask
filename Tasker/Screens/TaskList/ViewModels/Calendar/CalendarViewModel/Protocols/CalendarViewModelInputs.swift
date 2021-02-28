//
//  CalendarViewModelInputs.swift
//  Tasker
//
//  Created by KLuV on 16.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol CalendarViewModelInputs {
    func calculateDays()
    func setSelectedDay(dayViewModel: CalendarDayViewModelType)
    func setSelectedMonth(monthViewModel: CalendarMonthViewModelType)
    func selectCurrentDay()
    func updateTasksInDays(dateInfo: [Date])
}
