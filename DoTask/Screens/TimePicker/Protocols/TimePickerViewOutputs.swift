//
//  TimePickerInstance.swift
//  DoTask
//
//  Created by kluv on 30/09/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import Foundation

protocol TimePickerViewOutputs: AnyObject {
    var selectedReminderTime: Date? { get set }
    func completionAfterCloseTimePicker()
}
