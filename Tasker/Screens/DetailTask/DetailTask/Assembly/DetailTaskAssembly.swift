//
//  DetailTaskAssembly.swift
//  Tasker
//
//  Created by kluv on 23/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import Foundation

class DetailTaskAssembly {
    static func createInstance(taskUID: String?, presenter: PresenterController?) -> DetailTaskViewController {
        let dataSource: TaskListDataSource = TaskListDataSourceCoreDataImpl(context: CoreDataService.shared.context)
        let viewModel: DetailTaskViewModel = DetailTaskViewModel(taskUID: taskUID, dataSource: dataSource)
        return DetailTaskViewController(viewModel: viewModel, presenter: presenter, presentableControllerViewType: .modalViewController)
    }
}
