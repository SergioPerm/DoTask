//
//  TaskListViewModelOutputs.swift
//  DoTask
//
//  Created by KLuV on 27.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol TaskListViewModelOutputs {
    var periodItems: [TaskListPeriodItemViewModelType] { get }
    var shortcutFilter: Observable<ShortcutData?> { get }
    var taskDiaryMode: Observable<Bool> { get }
    var taskListMode: Observable<TaskListMode> { get }
    var calendarViewModel: CalendarViewModelType? { get }
    var calendarSelectedDate: Date? { get }
    var calendarMonth: Observable<Date> { get }
}
