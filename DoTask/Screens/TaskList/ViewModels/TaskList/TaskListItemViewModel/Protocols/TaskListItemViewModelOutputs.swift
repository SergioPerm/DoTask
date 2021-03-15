//
//  TaskListItemViewModelOutputs.swift
//  DoTask
//
//  Created by KLuV on 27.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol TaskListItemViewModelOutputs {
    var title: Observable<String> { get }
    var date: Observable<String> { get }
    var reminderTime: Observable<String?> { get }
    var importantColor: Observable<String?> { get }
    var shortcutColor: Observable<String?> { get }
    var isDone: Observable<Bool> { get }
    func getTaskUID() -> String
}
