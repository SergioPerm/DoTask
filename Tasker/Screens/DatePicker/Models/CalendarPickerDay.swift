//
//  DayModel.swift
//  ToDoList
//
//  Created by kluv on 06/09/2020.
//  Copyright © 2020 com.kluv.itotdel. All rights reserved.
//

import Foundation

struct CalendarPickerDay {
    let date: Date
    let number: String
    var isSelected: Bool
    let isWithinDisplayedMonth: Bool
    let isWeekend: Bool
    let currentDay: Bool
    let pastDate: Bool
}
