//
//  TaskRemiderInfoViewModelType.swift
//  Tasker
//
//  Created by KLuV on 01.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol TaskReminderInfoViewModelType {
    var inputs: TaskReminderInfoViewModelInputs { get }
    var outputs: TaskReminderInfoViewModelOutputs { get }
}
