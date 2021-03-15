//
//  TaskDiaryAssembly.swift
//  DoTask
//
//  Created by KLuV on 05.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

class TaskDiaryAssembly {
    static func createInstance(router: RouterType?) -> TaskDiaryViewPresentable {
                
        let dataSource: TaskListDataSource = TaskListDataSourceCoreData(context: CoreDataService.shared.context, shortcutFilter: nil, onlyFinishedTasksFilter: true)
        let viewModel: TaskDiaryViewModel = TaskDiaryViewModel(dataSource: dataSource)
        
        return TaskDiaryNavigationController(viewModel: viewModel, router: router, presentableControllerViewType: .presentWithTransition, persistentType: .none)
    }
}
