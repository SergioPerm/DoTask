//
//  DetailTaskViewModelOutputs.swift
//  Tasker
//
//  Created by kluv on 21/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

protocol DetailTaskViewModelOutputs {
    var selectedDate: Boxing<Date?> { get }
    var selectedTime: Boxing<Date?> { get }
    var selectedShortcut: Boxing<ShortcutData> { get }
    var shortcutUID: String? { get }
    var isNewTask: Bool { get }
    var importanceLevel: Int { get }
    var title: String { get }
    var tableSections: [DetailTaskTableSectionViewModelType] { get }
    var onReturnToEdit: Boxing<Bool> { get }
    //var subtasks: [SubtaskViewModelType] { get }
}
