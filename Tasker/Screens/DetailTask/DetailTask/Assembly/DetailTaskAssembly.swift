//
//  DetailTaskAssembly.swift
//  Tasker
//
//  Created by kluv on 23/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import Foundation

class DetailTaskAssembly {
    static func createInstance(taskUID: String?, shortcutUID: String?, taskDate: Date?, presenter: RouterType?) -> DetailTaskViewType {
        let dataSource: TaskListDataSource = TaskListDataSourceCoreData(context: CoreDataService.shared.context, shortcutFilter: nil)
        let viewModel: DetailTaskViewModel = DetailTaskViewModel(taskUID: taskUID, shortcutUID: shortcutUID, taskDate: taskDate, dataSource: dataSource)

        if let _ = taskUID {
            return DetailTaskEditViewController(viewModel: viewModel, presenter: presenter, presentableControllerViewType: .presentWithTransition)
        }
        
        return DetailTaskNewViewController(viewModel: viewModel, presenter: presenter, presentableControllerViewType: .presentWithTransition)
    }
}
