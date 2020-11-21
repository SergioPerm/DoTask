//
//  CalendarPickerViewModelInputs.swift
//  Tasker
//
//  Created by kluv on 19/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import Foundation

protocol CalendarPickerViewModelInputs {
    func calculateDays()
    func clearSelectedDay()
    func setSelectedDay(date: Date)
}
