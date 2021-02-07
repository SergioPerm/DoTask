//
//  DetailTaskViewModelInputs.swift
//  Tasker
//
//  Created by kluv on 21/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import Foundation

protocol DetailTaskViewModelInputs: class {
    func setTaskDate(date: Date?)
    func setReminder(date: Date?)
    func setTitle(title: String)
    func setShortcut(shortcutUID: String?)
    func increaseImportance()
    func addSubtask() -> IndexPath
    func deleteSubtask(indexPath: IndexPath)
    func moveSubtask(from: Int, to: Int)
    func saveTask()
    func deleteTask()
    func askForDelete()
    
    func setCalendarHandler(onCalendarSelect: ((_ selectedDate: Date?, _ vc: CalendarPickerViewOutputs) -> Void)?)
    func setReminderHandler(onTimeReminderSelect: ((_ selectedTime: Date, _ vc: TimePickerViewOutputs) -> Void)?)
    func setShortcutHandler(onShortcutSelect: ((String?, ShortcutListViewOutputs) -> Void)?)
    
    func openCalendar()
    func openReminder()
    func openShortcuts()
}
