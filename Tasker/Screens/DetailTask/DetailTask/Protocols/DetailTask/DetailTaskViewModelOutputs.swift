//
//  DetailTaskViewModelOutputs.swift
//  Tasker
//
//  Created by kluv on 21/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import Foundation

protocol DetailTaskViewModelOutputs {
    var selectedDate: Boxing<Date?> { get }
    var selectedTime: Boxing<Date?> { get }
    var importanceLevel: Int { get }
    var title: String { get }
    var subtasks: [SubtaskViewModelType] { get }
}
