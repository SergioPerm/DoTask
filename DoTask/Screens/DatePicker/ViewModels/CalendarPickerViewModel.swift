//
//  CalendarPickerViewModel.swift
//  DoTask
//
//  Created by kluv on 18/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import Foundation

class CalendarPickerViewModel: CalendarPickerViewModelType, CalendarPickerViewModelInputs, CalendarPickerViewModelOutputs {
   
    // MARK: CalendarPickerViewModelType
    
    var inputs: CalendarPickerViewModelInputs { return self }
    var outputs: CalendarPickerViewModelOutputs { return self }
    
    // MARK: Outputs
    var days: Boxing<[CalendarPickerMonth]>
    var selectedDate: Boxing<Date?>
        
    // MARK: Inputs
    func calculateDays() {
        days.value = generateDaysForThreeYears()
    }
    
    func clearSelectedDay() {
        selectedDate.value = nil
    }
    
    func setSelectedDay(date: Date) {
        selectedDate.value = date
    }
    
    // MARK: Properties
    
    private let baseDate = Date()
    private let calendar = Calendar.current.taskCalendar
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter
    }()
    
    enum CalendarDataError: Error {
      case metadataGeneration
    }
            
    // MARK: Initializers
    
    init(selectedDate: Date?) {
        self.selectedDate = Boxing(selectedDate)
        self.days = Boxing([])
    }
        
    // MARK: Calendar calculations
    
    private func generateDaysForThreeYears() -> [CalendarPickerMonth] {
        var yearComponent = DateComponents()
        var allMonths: [CalendarPickerMonth] = []
        allMonths.removeAll()
        
        var startDate = Date()
        if let selectedDate = selectedDate.value {
            startDate = (selectedDate.startOfDay() - Date().startOfDay()) < 0 ? selectedDate : Date()
        }
        
        for year in 0...2 {
            yearComponent.year = year
            
            var yearDate = Date()
            if year != 0 {
                yearDate = baseDate
            } else {
                yearDate = calendar.date(byAdding: yearComponent, to: startDate)!
            }
            
            let yearNum = calendar.component(.year, from: yearDate)

            var firstDayInYear = yearDate
            if year > 0 {
                firstDayInYear = calendar.date(from: DateComponents(year: yearNum, month: 1, day: 1))!
            }
            
            let monthNumber = calendar.component(.month, from: firstDayInYear)

            for month in monthNumber...12 {
                let currentMonthDate = calendar.date(from: DateComponents(year: yearNum, month: month, day: 1))!
                allMonths.append(generateMonth(for: currentMonthDate))
            }
            
        }
        
        return allMonths
    }
    
    private func getWeekday(from weekdayDate: Date) -> Int {
        let weekDay = calendar.component(.weekday, from: weekdayDate.localDate())
        return weekDay == 1 ? 7 : weekDay - 1
    }
    
    private func monthModel(from monthDate: Date) throws -> CalendarPickerMonth {
        guard
            let numberOfDaysInMonth = calendar.range(of: .day, in: .month, for: monthDate)?.count,
            let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: monthDate)) else {
                throw CalendarDataError.metadataGeneration
        }
        
        let firstDayWeekday = getWeekday(from: firstDayOfMonth)
        let offsetInInitialRow = firstDayWeekday
        
        var days: [CalendarPickerDay] = (1..<(numberOfDaysInMonth + offsetInInitialRow)).map { day in
            let isWithinDisplayedMonth = day >= offsetInInitialRow
            let dayOffset = isWithinDisplayedMonth ? day - offsetInInitialRow : -(offsetInInitialRow - day)
            
            return generateDay(offsetBy: dayOffset, for: firstDayOfMonth, isWithinDisplayedMonth: isWithinDisplayedMonth)
        }
        
        days += generateStartOfNextMonth(using: firstDayOfMonth, totalDays: days.count)
        
        return CalendarPickerMonth(numberOfDays: numberOfDaysInMonth, firstDay: firstDayOfMonth, firstDayWeekday: firstDayWeekday, days: days)
    }
    
    private func generateMonth(for monthDate: Date) -> CalendarPickerMonth {
        guard let monthData = try? monthModel(from: monthDate) else {
            fatalError("An error occurred when generating the metadata for \(monthDate)")
        }
        
        return monthData
    }
    
    private func generateDaysInMonth(for baseDate: Date) -> [CalendarPickerDay] {
        guard let monthData = try? monthModel(from: baseDate) else {
            fatalError("An error occurred when generating the metadata for \(baseDate)")
        }
        
        let numberOfDaysInMonth = monthData.numberOfDays
        let offsetInInitialRow = monthData.firstDayWeekday
        let firstDayOfMonth = monthData.firstDay

        var days: [CalendarPickerDay] = (1..<(numberOfDaysInMonth + offsetInInitialRow)).map { day in

            let isWithinDisplayedMonth = day >= offsetInInitialRow
            let dayOffset = isWithinDisplayedMonth ? day - offsetInInitialRow : -(offsetInInitialRow - day)

            return generateDay(offsetBy: dayOffset, for: firstDayOfMonth, isWithinDisplayedMonth: isWithinDisplayedMonth)
        }

        days += generateStartOfNextMonth(using: firstDayOfMonth, totalDays: days.count)
        
        return days
    }
    
    private func generateStartOfNextMonth(using firstDayOfDisplayedMonth: Date, totalDays: Int) -> [CalendarPickerDay] {
        guard let lastDayInMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1),to: firstDayOfDisplayedMonth) else {
            return []
        }
        
        let additionalDays = 42 - totalDays//14 - calendar.component(.weekday, from: lastDayInMonth)
               
        guard additionalDays > 0 else {
            return []
        }
                
        let days: [CalendarPickerDay] = (1...additionalDays)
            .map {
                generateDay(
                    offsetBy: $0,
                    for: lastDayInMonth,
                    isWithinDisplayedMonth: false)
        }
        
        return days
    }
    
    private func generateDay(offsetBy dayOffset: Int, for firstDayOfMonth: Date, isWithinDisplayedMonth: Bool) -> CalendarPickerDay {
        let dayDate = calendar.date(byAdding: .day, value: dayOffset, to: firstDayOfMonth)!
        let weekDay = getWeekday(from: dayDate)

        let isCurrentDay = calendar.isDate(dayDate, equalTo: baseDate, toGranularity: .day)
        var isSelected = false
        
        if let selectDate = selectedDate.value {
            isSelected = calendar.isDate(dayDate, equalTo: selectDate, toGranularity: .day) && isWithinDisplayedMonth
        }
        
        let pastDate = (dayDate.startOfDay().timeIntervalSinceReferenceDate - Date().startOfDay().timeIntervalSinceReferenceDate) < 0 ? true : false
        
        return CalendarPickerDay(date: dayDate, number: dateFormatter.string(from: dayDate),
                        isSelected: isSelected,
                        isWithinDisplayedMonth: isWithinDisplayedMonth,
                        isWeekend: weekDay > 5 ? true : false,
                        currentDay: isCurrentDay,
                        pastDate: pastDate)
    }
    
}
