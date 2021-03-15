//
//  TaskDiaryItemViewModelOutputs.swift
//  DoTask
//
//  Created by KLuV on 04.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol TaskDiaryItemViewModelOutputs {
    var title: Observable<String> { get }
    var date: Observable<String> { get }
    var reminderTime: Observable<String?> { get }
    var importantColor: Observable<String?> { get }
    var shortcutColor: Observable<String?> { get }
    func getTaskUID() -> String
}
