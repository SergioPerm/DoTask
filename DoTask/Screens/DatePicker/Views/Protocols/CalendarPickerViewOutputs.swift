//
//  CalendarPickerInstance.swift
//  DoTask
//
//  Created by kluv on 29/09/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import Foundation

protocol CalendarPickerViewOutputs: class {
    var selectedCalendarDate: Date? { get set }
    func comletionAfterCloseCalendar()
}
