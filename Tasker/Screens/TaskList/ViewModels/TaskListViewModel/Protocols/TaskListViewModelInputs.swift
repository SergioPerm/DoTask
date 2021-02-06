//
//  TaskListViewModelInputs.swift
//  Tasker
//
//  Created by KLuV on 27.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol TaskListViewModelInputs {
//    func setShortcutFilter(shortcutUID: String?)
//    func setTaskDiaryMode()
    func setFilter(filter: TaskListFilter)
    func editTask(indexPath: IndexPath)
}
