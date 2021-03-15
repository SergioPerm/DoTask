//
//  DetailTaskViewModelOutputs.swift
//  DoTask
//
//  Created by kluv on 21/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

protocol DetailTaskViewModelOutputs {
    var selectedDate: Observable<Date?> { get }
    var selectedTime: Observable<Date?> { get }
    var selectedShortcut: Observable<ShortcutData> { get }
    var shortcutUID: String? { get }
    var isNewTask: Bool { get }
    var isDone: Bool { get }
    var importanceLevel: Int { get }
    var title: String { get }
    var tableSections: [DetailTaskTableSectionViewModelType] { get }
    var onReturnToEdit: Observable<Bool> { get }
    var asksToDelete: Observable<Bool> { get }
}
