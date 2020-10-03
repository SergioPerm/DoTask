//
//  TimePickerInstance.swift
//  Tasker
//
//  Created by kluv on 30/09/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import Foundation

protocol TimePickerInstance: class {
    var selectedReminderTime: Date? { get set }
    func closeTimePicker()
}
