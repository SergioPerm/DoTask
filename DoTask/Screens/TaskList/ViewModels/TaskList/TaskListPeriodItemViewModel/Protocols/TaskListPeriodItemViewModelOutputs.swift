//
//  TaskListPeriodItemViewModelOutputs.swift
//  DoTask
//
//  Created by KLuV on 16.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

struct DoneCounter {
    var allCount: Int
    var doneCount: Int
}

protocol TaskListPeriodItemViewModelOutputs {
    var title: String { get }
    var titleHexColor: String { get }
    var dailyName: DailyName? { get }
    var tasks: [TaskListItemType] { get }
    var taskListMode: TaskListMode { get }
    var isEmpty: Bool { get }
    var showingCapWhenTasksIsEmpty: Bool { get }
    var capMode: EmptyCapMode? { get }
    var doneCounter: DoneCounter? { get }
    
    var doneCounterEvent: Event<DoneCounter?> { get }
}
