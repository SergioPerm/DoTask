//
//  TaskListAssembly.swift
//  Tasker
//
//  Created by kluv on 22/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import Foundation

class TaskListAssembly {
    static func createInstance(presenter: PresenterController?) -> TaskListViewController {
        let dataSource: TaskListDataSource = TaskListDataSourceCoreData(context: CoreDataService.shared.context)
        let viewModel: TaskListViewModel = TaskListViewModel(dataSource: dataSource)
        return TaskListViewController(viewModel: viewModel, presenter: presenter, presentableControllerViewType: .navigationStackController)
    }
}
