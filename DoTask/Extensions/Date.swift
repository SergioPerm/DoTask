//
//  Date.swift
//  DoTask
//
//  Created by kluv on 30/09/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import Foundation

enum DailyName: String, CaseIterable {
    case today = "DAILY_TODAY"
    case tommorow = "TOMORROW"
    case currentWeek = "CURRENT_WEEK"
    case later = "LATER"
    
    func haveDoneCounter() -> Bool {
        return self == .today ? true : false
    }
    
    func localized() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
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
            
    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
    
    func dailyNameForTask() -> DailyName {
        let calendar = Calendar.current.taskCalendar
        let currentDate = calendar.startOfDay(for: Date())
        
        if self < currentDate {
            return DailyName.today
        }
        
        let isCurrentDay = calendar.isDateInToday(self)
        let isTomorrowDay = calendar.isDateInTomorrow(self)
        
        if isCurrentDay {
            return DailyName.today
        } else if isTomorrowDay {
            return DailyName.tommorow
        } else if calendar.isDate(self, equalTo: Date(), toGranularity: .weekOfMonth) {
            return DailyName.currentWeek
        }
        
        return DailyName.later
    }
    
    func localDate() -> Date {
        let nowUTC = self
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC) else {return self}

        return localDate
    }
}
