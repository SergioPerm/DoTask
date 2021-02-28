//
//  Date.swift
//  Tasker
//
//  Created by kluv on 30/09/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import Foundation

enum DailyName: String, CaseIterable {
    case today = "TODAY"
    case tommorow = "TOMORROW"
    case currentWeek = "CURRENT WEEK"
    case later = "LATER"
}

extension Date {
    
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    
    var startOfMonth: Date {

        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)

        return  calendar.date(from: components)!
    }
    
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
    }
    
    func isDayToday() -> Bool {
        let calendar = Calendar.current.taskCalendar
        return calendar.isDateInToday(self)
    }
    
    func startOfDay() -> Date {
        let calendar = Calendar.current.taskCalendar
        return calendar.startOfDay(for: self)
    }
    
    func endOfDay() -> Date {
        let calendar = Calendar.current.taskCalendar
        
        if let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: self) {
            return endOfDay
        } else {
            return self
        }
    }
    
    func dailyNameForTask() -> String {
        let calendar = Calendar.current.taskCalendar
        let currentDate = calendar.startOfDay(for: Date())
        
        if self < currentDate {
            return DailyName.today.rawValue
        }
        
        let isCurrentDay = calendar.isDateInToday(self)
        let isTomorrowDay = calendar.isDateInTomorrow(self)
        
        if isCurrentDay {
            return DailyName.today.rawValue
        } else if isTomorrowDay {
            return DailyName.tommorow.rawValue
        } else if calendar.isDate(self, equalTo: Date(), toGranularity: .weekOfMonth) {
            return DailyName.currentWeek.rawValue
        }
        
        return DailyName.later.rawValue
    }
    
    func localDate() -> Date {
        let nowUTC = self
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC) else {return self}

        return localDate
    }
}
