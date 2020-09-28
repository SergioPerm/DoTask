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
    var tasksWithSections: [DailyModel] { get }
    var observer: TaskListDataSourceObserver? { get set }

    func taskForIndexPath(indexPath: IndexPath) -> TaskModel
    func addTask(from taskModel: TaskModel)
    func deleteTask(task: Task)
    func updateTask(from taskModel: TaskModel)
    func clearData()
}
