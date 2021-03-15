//
//  Month.swift
//  ToDoList
//
//  Created by kluv on 06/09/2020.
//  Copyright © 2020 com.kluv.itotdel. All rights reserved.
//

import Foundation

struct CalendarPickerMonth {
    let numberOfDays: Int
    let firstDay: Date
    let firstDayWeekday: Int
    let days: [CalendarPickerDay]
}
