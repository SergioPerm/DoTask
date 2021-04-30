//
//  CalendarPickerViewModelType.swift
//  DoTask
//
//  Created by kluv on 18/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import Foundation

protocol CalendarPickerViewModelType: AnyObject {
    var inputs: CalendarPickerViewModelInputs { get }
    var outputs: CalendarPickerViewModelOutputs { get }
}
