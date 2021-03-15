//
//  TaskListItemViewModelOutputs.swift
//  DoTask
//
//  Created by KLuV on 27.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol TaskListItemViewModelOutputs {
    var title: Boxing<String> { get }
    var date: Boxing<String> { get }
    var reminderTime: Boxing<String?> { get }
    var importantColor: Boxing<String?> { get }
    var shortcutColor: Boxing<String?> { get }
    var isDone: Boxing<Bool> { get }
    func getTaskUID() -> String
}
