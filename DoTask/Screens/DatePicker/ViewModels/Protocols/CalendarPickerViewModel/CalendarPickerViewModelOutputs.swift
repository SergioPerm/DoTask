//
//  CalendarPickerViewModelOutputs.swift
//  DoTask
//
//  Created by kluv on 21/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import Foundation

protocol CalendarPickerViewModelOutputs {
    var selectedDate: Observable<Date?> { get set}
    var days: Observable<[CalendarPickerMonth]> { get }
}
