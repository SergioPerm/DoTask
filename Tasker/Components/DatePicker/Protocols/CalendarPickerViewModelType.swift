//
//  CalendarPickerViewModelType.swift
//  Tasker
//
//  Created by kluv on 18/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import Foundation

protocol CalendarPickerViewModelType: class {
    var baseDate: Boxing<Date> { get }
    var selectedDate: Boxing<Date?> { get set}
    var days: Boxing<[MonthModel]> { get }
    
    func calculateDays()
}
