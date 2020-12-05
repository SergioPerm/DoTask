//
//  TaskListDataSource.swift
//  Tasker
//
//  Created by kluv on 27/09/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//
import UIKit

protocol TaskListDataSource {
    var tasks: [Task] { get }
    var tasksWithSections: [Daily] { get }
    var observer: TaskListDataSourceObserver? { get set }

    func setDoneForTask(with identifier: String)
    func taskByIdentifier(identifier: String) -> Task?
    func taskModelByIdentifier(identifier: String?) -> TaskModel?
    func taskModelForIndexPath(indexPath: IndexPath) -> TaskModel
    func taskForTaskModel(taskModel: TaskModel) -> Task?
    func addTask(from taskModel: TaskModel)
    func deleteTask(from taskModel: TaskModel)
    func updateTask(from taskModel: TaskModel)
    func clearData()
}
