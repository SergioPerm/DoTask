//
//  CalendarMonth.swift
//  DoTask
//
//  Created by KLuV on 16.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

struct CalendarMonth {
    let numberOfDays: Int
    let firstDay: Date
    let firstDayWeekday: Int
    let days: [CalendarDay]
}
