//
//  CalendarDayViewModelOutputs.swift
//  DoTask
//
//  Created by KLuV on 16.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol CalendarDayViewModelOutputs {
    var dayWithStatus: CalendarDayStatus { get }
    var dayString: String { get }
    var isWithinDisplayedMonth: Bool { get }
    var isWeekend: Bool { get }
    var isSelected: Bool { get }
    var currentDay: Bool { get }
    var date: Date { get }
    
    //Events
    var dayWithStatusEvent: Event<CalendarDayStatus> { get }
    var isSelectedEvent: Event<Bool> { get }
}
