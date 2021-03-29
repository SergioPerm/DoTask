//
//  TasklistPeriodItemViewModelInputs.swift
//  DoTask
//
//  Created by KLuV on 16.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol TaskListPeriodItemViewModelInputs {
    func insert(task: TaskListItemViewModelType, at index: Int)
    func insert(task: TaskListItemViewModelType)
    func remove(at index: Int)
    func setTaskListMode(mode: TaskListMode)
    func setShowingCapWhenTasksIsEmpty(emptyState: Bool, capMode: EmptyCapMode?)
    func setDoneCounter(counter: DoneCounter)
}
