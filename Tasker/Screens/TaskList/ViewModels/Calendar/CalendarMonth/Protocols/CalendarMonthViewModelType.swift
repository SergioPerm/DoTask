//
//  CalendarMonthViewModelOutputs.swift
//  Tasker
//
//  Created by KLuV on 16.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol CalendarMonthViewModelType {
    var days: [CalendarDayViewModelType] { get set }
    var year: Int { get set }
    var month: Int { get set }
}
