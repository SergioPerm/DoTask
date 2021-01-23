//
//  DetailTaskAssembly.swift
//  Tasker
//
//  Created by kluv on 23/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import Foundation

class DetailTaskAssembly {
    static func createInstance(taskUID: String?, presenter: RouterType?) -> DetailTaskViewType {
        let dataSource: TaskListDataSource = TaskListDataSourceCoreData(context: CoreDataService.shared.context)
        let viewModel: DetailTaskViewModel = DetailTaskViewModel(taskUID: taskUID, dataSource: dataSource)

        if let _ = taskUID {
            return DetailTaskEditViewController(viewModel: viewModel, presenter: presenter, presentableControllerViewType: .containerChild)
        }
        
        return DetailTaskNewViewController(viewModel: viewModel, presenter: presenter, presentableControllerViewType: .containerChild)
    }
}
