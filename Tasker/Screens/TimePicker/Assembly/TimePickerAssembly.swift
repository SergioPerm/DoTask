//
//  TimePickerAssembly.swift
//  Tasker
//
//  Created by kluv on 23/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import Foundation

class TimePickerAssembly {
    static func createInstance(date: Date?, presenter: PresenterController?) -> TimePickerViewController {
        return TimePickerViewController(baseTime: date, presenter: presenter, presentableControllerViewType: .modalViewController)
    }
}
