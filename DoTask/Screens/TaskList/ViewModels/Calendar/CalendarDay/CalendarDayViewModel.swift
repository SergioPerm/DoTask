//
//  CalendarDayViewModel.swift
//  DoTask
//
//  Created by KLuV on 17.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol CalendarDayViewModelInputs {
    func setSelectDay(selected: Bool)
    func setDayStatus(status: CalendarDayStatus)
}

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

protocol CalendarDayViewModelType {
    var inputs: CalendarDayViewModelInputs { get }
    var outputs: CalendarDayViewModelOutputs { get }
    
    //func unbind()
}

class CalendarDayViewModel: CalendarDayViewModelType, CalendarDayViewModelInputs, CalendarDayViewModelOutputs {
    
    private var calendarDay: CalendarDay
    
    var inputs: CalendarDayViewModelInputs { return self }
    var outputs: CalendarDayViewModelOutputs { return self }
    
    init(calendarDay: CalendarDay, status: CalendarDayStatus) {
        self.calendarDay = calendarDay
        self.dayWithStatus = status
        self.dayWithStatusEvent = Event<CalendarDayStatus>()
        self.isSelectedEvent = Event<Bool>()
        self.isSelected = calendarDay.isSelected
        
        self.isSelectedEvent.raise(calendarDay.isSelected)
    }
    
    // MARK: Inputs
        
    func setDayStatus(status: CalendarDayStatus) {
        dayWithStatus = status
        dayWithStatusEvent.raise(status)
    }
    
    func setSelectDay(selected: Bool) {
        calendarDay.isSelected = selected
        isSelected = selected
        isSelectedEvent.raise(selected)
    }
    
    // MARK: Outputs
        
    var dayWithStatusEvent: Event<CalendarDayStatus>
    var dayWithStatus: CalendarDayStatus
    
    var dayString: String {
        return calendarDay.number
    }
    
    var isWithinDisplayedMonth: Bool {
        return calendarDay.isWithinDisplayedMonth
    }
    
    var isWeekend: Bool {
        return calendarDay.isWeekend
    }
    
    var isSelectedEvent: Event<Bool>
    
    var isSelected: Bool
    
    var currentDay: Bool {
        return calendarDay.currentDay
    }
    
    var date: Date {
        return calendarDay.date
    }
}
