//
//  CalendarViewModel.swift
//  Tasker
//
//  Created by KLuV on 16.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

class CalendarViewModel: CalendarViewModelType, CalendarViewModelInputs, CalendarViewModelOutputs {
  
    var inputs: CalendarViewModelInputs { return self }
    var outputs: CalendarViewModelOutputs { return self }
    
    //date of the first task
    private var startDate: Date
    
    private let calendar = Calendar.current.taskCalendar
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        return dateFormatter
    }()
    
    var selectedDateHandler: ((_: Date) -> Void)?
    var setCalendarMonthHandler: ((_: String?) -> Void)?
    
    enum CalendarDataError: Error {
      case metadataGeneration
    }
    
    private var currentDay: CalendarDayViewModelType?
    
    init(startDate: Date) {
        self.startDate = startDate
        self.selectedDate = Boxing(Date())
        self.calendarData = []
        self.focusDate = Boxing(Date())
        
        calculateDays()
    }
    
    // MARK: Inputs
        
    func selectCurrentDay() {
        if let selectedDay = selectedDay {
            selectedDay.inputs.setSelectDay(selected: false)
        }
        
        currentDay?.inputs.setSelectDay(selected: true)
        selectedDay = currentDay
    }
    
    func calculateDays() {
        let monthsData = generateDaysForThreeYears()
        
        if let selectedDay = selectedDay {
            selectedDay.inputs.setSelectDay(selected: false)
        }
        
        monthsData.forEach { calendarMonth in
            var daysData: [CalendarDayViewModelType] = []
            calendarMonth.days.forEach { calendarDay in
                let dayViewModel = CalendarDayViewModel(calendarDay: calendarDay, withTasks: false)
                
                if calendarDay.currentDay {
                    selectedDay = dayViewModel
                    currentDay = dayViewModel
                }
                
                daysData.append(dayViewModel)
            }
            
            calendarData.append(CalendarMonthViewModel(with: daysData))
        }
    }
    
    func setSelectedMonth(monthViewModel: CalendarMonthViewModelType) {
        let monthName = dateFormatter.monthSymbols[monthViewModel.month - 1]
        
        if let setCalendarMonthAction = setCalendarMonthHandler {
            setCalendarMonthAction(monthName)
        }
    }
    
    func setSelectedDay(dayViewModel: CalendarDayViewModelType) {
        if let selectedDay = selectedDay {
            selectedDay.inputs.setSelectDay(selected: false)
        }
        
        dayViewModel.inputs.setSelectDay(selected: true)
        selectedDay = dayViewModel
        
        if let selectDateAction = selectedDateHandler {
            selectDateAction(dayViewModel.outputs.date)
        }
    }
    
    func updateTasksInDays(dateInfo: [Date]) {
        
        //reset check tasks
        calendarData.forEach({
            $0.days.forEach({
                //if $0.outputs.dayWithTasks.value {
                    $0.inputs.setDayWithTask(haveTasks: false)
                //}
            })
        })
        
        let dateInfo = Array(Set(dateInfo.map {
            $0.startOfDay()
        }))
        
        struct MonthYearInfo: Hashable {
            let year: Int
            let month: Int
        }
        
        let monthYearGroupDates = Dictionary(grouping: dateInfo, by: {
            MonthYearInfo(year: Calendar.current.component(.year, from: $0), month: Calendar.current.component(.month, from: $0))
        })
            
        monthYearGroupDates.forEach { monthYear in
            let calendarMonthViewModel = calendarData.first(where: {
                $0.year == monthYear.key.year && $0.month == monthYear.key.month
            })
            
            if let calendarMonthViewModel = calendarMonthViewModel {
                monthYear.value.forEach { date in
                    let calendarDayViewModel = calendarMonthViewModel.days.first(where: {
                        $0.outputs.date == date
                    })
                    
                    if let calendarDayViewModel = calendarDayViewModel {
                        calendarDayViewModel.inputs.setDayWithTask(haveTasks: true)
                    }
                }
            }
        }
                
    }
    
    // MARK: Outputs
    
    var selectedDate: Boxing<Date?>
    var calendarData: [CalendarMonthViewModelType]
    var selectedDay: CalendarDayViewModelType?
    var focusDate: Boxing<Date>
    
}

extension CalendarViewModel {
    
    // MARK: Calendar calculations
    
    private func generateDaysForThreeYears() -> [CalendarMonth] {
        var allMonths: [CalendarMonth] = []
                                
        let components = Set<Calendar.Component>([.year])
        let differenceOfDate = Calendar.current.dateComponents(components, from: startDate, to: Date())
            
        let yearsCount = (differenceOfDate.year ?? 0) + 3
        var yearNum = calendar.component(.year, from: startDate)
        
        for _ in 0...yearsCount {
            let firstDayInYear = calendar.date(from: DateComponents(year: yearNum, month: 1, day: 1))!

            let monthNumber = calendar.component(.month, from: firstDayInYear)

            for month in monthNumber...12 {
                let currentMonthDate = calendar.date(from: DateComponents(year: yearNum, month: month, day: 1))!
                allMonths.append(generateMonth(for: currentMonthDate))
            }

            yearNum += 1
        }
        
        return allMonths
    }
    
    private func getWeekday(from weekdayDate: Date) -> Int {
        let weekDay = calendar.component(.weekday, from: weekdayDate.localDate())
        return weekDay == 1 ? 7 : weekDay - 1
    }

    private func monthModel(from monthDate: Date) throws -> CalendarMonth {
        guard
            let numberOfDaysInMonth = calendar.range(of: .day, in: .month, for: monthDate)?.count,
            let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: monthDate)) else {
                throw CalendarDataError.metadataGeneration
        }

        let firstDayWeekday = getWeekday(from: firstDayOfMonth)
        let offsetInInitialRow = firstDayWeekday

        var days: [CalendarDay] = (1..<(numberOfDaysInMonth + offsetInInitialRow)).map { day in
            let isWithinDisplayedMonth = day >= offsetInInitialRow
            let dayOffset = isWithinDisplayedMonth ? day - offsetInInitialRow : -(offsetInInitialRow - day)

            return generateDay(offsetBy: dayOffset, for: firstDayOfMonth, isWithinDisplayedMonth: isWithinDisplayedMonth)
        }

        days += generateStartOfNextMonth(using: firstDayOfMonth, totalDays: days.count)

        return CalendarMonth(numberOfDays: numberOfDaysInMonth, firstDay: firstDayOfMonth, firstDayWeekday: firstDayWeekday, days: days)
    }

    private func generateMonth(for monthDate: Date) -> CalendarMonth {
        guard let monthData = try? monthModel(from: monthDate) else {
            fatalError("An error occurred when generating the metadata for \(monthDate)")
        }

        return monthData
    }

    private func generateDaysInMonth(for baseDate: Date) -> [CalendarDay] {
        guard let monthData = try? monthModel(from: baseDate) else {
            fatalError("An error occurred when generating the metadata for \(baseDate)")
        }

        let numberOfDaysInMonth = monthData.numberOfDays
        let offsetInInitialRow = monthData.firstDayWeekday
        let firstDayOfMonth = monthData.firstDay

        var days: [CalendarDay] = (1..<(numberOfDaysInMonth + offsetInInitialRow)).map { day in

            let isWithinDisplayedMonth = day >= offsetInInitialRow
            let dayOffset = isWithinDisplayedMonth ? day - offsetInInitialRow : -(offsetInInitialRow - day)

            return generateDay(offsetBy: dayOffset, for: firstDayOfMonth, isWithinDisplayedMonth: isWithinDisplayedMonth)
        }

        days += generateStartOfNextMonth(using: firstDayOfMonth, totalDays: days.count)

        return days
    }

    private func generateStartOfNextMonth(using firstDayOfDisplayedMonth: Date, totalDays: Int) -> [CalendarDay] {
        guard let lastDayInMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1),to: firstDayOfDisplayedMonth) else {
            return []
        }

        let additionalDays = 42 - totalDays

        guard additionalDays > 0 else {
            return []
        }

        let days: [CalendarDay] = (1...additionalDays)
            .map {
                generateDay(
                    offsetBy: $0,
                    for: lastDayInMonth,
                    isWithinDisplayedMonth: false)
        }

        return days
    }

    private func generateDay(offsetBy dayOffset: Int, for firstDayOfMonth: Date, isWithinDisplayedMonth: Bool) -> CalendarDay {
        let dayDate = calendar.date(byAdding: .day, value: dayOffset, to: firstDayOfMonth)!
        let weekDay = getWeekday(from: dayDate)

        let isCurrentDay = calendar.isDate(dayDate, equalTo: Date(), toGranularity: .day)
        var isSelected = false
        
        if let selectDate = selectedDate.value {
            isSelected = calendar.isDate(dayDate, equalTo: selectDate, toGranularity: .day) && isWithinDisplayedMonth
        }

        dateFormatter.dateFormat = "d"
        
        return CalendarDay(date: dayDate, number: dateFormatter.string(from: dayDate),
                        isSelected: isSelected,
                        isWithinDisplayedMonth: isWithinDisplayedMonth,
                        isWeekend: weekDay > 5 ? true : false,
                        currentDay: isCurrentDay)
    }
    
}
