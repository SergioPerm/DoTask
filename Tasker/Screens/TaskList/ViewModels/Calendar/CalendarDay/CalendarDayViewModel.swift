//
//  CalendarDayViewModel.swift
//  Tasker
//
//  Created by KLuV on 17.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

class CalendarDayViewModel: CalendarDayViewModelType, CalendarDayViewModelInputs, CalendarDayViewModelOutputs {
    
    private var calendarDay: CalendarDay
    
    var inputs: CalendarDayViewModelInputs { return self }
    var outputs: CalendarDayViewModelOutputs { return self }
    
    init(calendarDay: CalendarDay, withTasks: Bool) {
        self.calendarDay = calendarDay
        self.dayWithTasks = withTasks
        self.isSelectedEvent = Event<Bool>()//Boxing(calendarDay.isSelected)
        self.isSelected = calendarDay.isSelected
        
        self.dayWithTasksEvent = Event<Bool>()
        
        self.dayWithTasksEvent.raise(withTasks)
        self.isSelectedEvent.raise(calendarDay.isSelected)
    }
    
    // MARK: Inputs
    
    func setDayWithTask(haveTasks: Bool) {
        dayWithTasks = haveTasks
        dayWithTasksEvent.raise(haveTasks)
    }
    
    func setSelectDay(selected: Bool) {
        calendarDay.isSelected = selected
        isSelected = selected
        isSelectedEvent.raise(selected)
    }
    
    // MARK: Outputs
    
    var dayWithTasksEvent: Event<Bool>
    
    var dayWithTasks: Bool
    
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
//
//
//    func unbind() {
//        isSelected = Boxing(isSelected.value)
//        dayWithTasks = Boxing(dayWithTasks.value)
//    }
}
