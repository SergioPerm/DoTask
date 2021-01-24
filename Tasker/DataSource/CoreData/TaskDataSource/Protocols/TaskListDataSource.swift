//
//  TaskListDataSource.swift
//  Tasker
//
//  Created by kluv on 27/09/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//
import Foundation

protocol TaskListDataSource {
    var tasks: [TaskManaged] { get }
    var tasksWithSections: [Daily] { get }
    var observer: TaskListDataSourceObserver? { get set }

    func setDoneForTask(with identifier: String)
    func taskByIdentifier(identifier: String) -> TaskManaged?
    func shortcutModelByIdentifier(identifier: String) -> Shortcut?
    func taskModelByIdentifier(identifier: String?) -> Task?
    func taskModelForIndexPath(indexPath: IndexPath) -> Task
    func taskForTaskModel(taskModel: Task) -> TaskManaged?
    func addTask(from taskModel: Task)
    func deleteTask(from taskModel: Task)
    func updateTask(from taskModel: Task)
    func clearData()
    
    func applyShortcutFilter(shortcutFilter: String?)
}
