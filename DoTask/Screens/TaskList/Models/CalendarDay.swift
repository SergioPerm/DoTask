//
//  CalendarDay.swift
//  DoTask
//
//  Created by KLuV on 16.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

struct CalendarDay {
    let date: Date
    let number: String
    var isSelected: Bool
    let isWithinDisplayedMonth: Bool
    let isWeekend: Bool
    let currentDay: Bool
}
