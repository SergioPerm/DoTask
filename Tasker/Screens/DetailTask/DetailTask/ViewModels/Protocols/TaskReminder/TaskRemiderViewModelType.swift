//
//  TaskRemiderInfoViewModelType.swift
//  Tasker
//
//  Created by KLuV on 01.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol TaskReminderViewModelType {
    var inputs: TaskReminderViewModelInputs { get }
    var outputs: TaskReminderViewModelOutputs { get }
}
