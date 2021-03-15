//
//  CalendarViewModelOutputs.swift
//  DoTask
//
//  Created by KLuV on 16.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol CalendarViewModelOutputs {
    var selectedDate: Boxing<Date?> { get set }
    var selectedDay: CalendarDayViewModelType? { get }
    var calendarData: [CalendarMonthViewModelType] { get }
    var focusDate: Boxing<Date> { get }
}
