//
//  TaskDiaryItemViewModelOutputs.swift
//  DoTask
//
//  Created by KLuV on 04.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol TaskDiaryItemViewModelOutputs {
    var title: Boxing<String> { get }
    var date: Boxing<String> { get }
    var reminderTime: Boxing<String?> { get }
    var importantColor: Boxing<String?> { get }
    var shortcutColor: Boxing<String?> { get }
    func getTaskUID() -> String
}
