//
//  DetailTaskViewModelInputs.swift
//  Tasker
//
//  Created by kluv on 21/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import Foundation

protocol DetailTaskViewModelInputs {
    func setTaskDate(date: Date?)
    func setReminder(date: Date?)
    func setTitle(title: String)
    func increaseImportance()
    func changeSubtasks(subtasks: [SubtaskViewModelType])
    func saveTask()
}
