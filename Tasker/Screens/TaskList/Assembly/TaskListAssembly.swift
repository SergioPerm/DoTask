//
//  TaskListAssembly.swift
//  Tasker
//
//  Created by kluv on 22/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import Foundation

class TaskListAssembly {
    static func createInstance(router: RouterType?, shortcutFilter: String?) -> TaskListViewController {
        
        if let persistentVC = router?.getPersistentViewController(persistentType: .taskList) as? TaskListViewController {
            persistentVC.shortcutFilter = nil
            if let shortcutFilter = shortcutFilter {
                persistentVC.shortcutFilter = shortcutFilter
            }
            return persistentVC
        }
        
        let dataSource: TaskListDataSource = TaskListDataSourceCoreData(context: CoreDataService.shared.context, shortcutFilter: shortcutFilter)
        let viewModel: TaskListViewModel = TaskListViewModel(dataSource: dataSource)
        return TaskListViewController(viewModel: viewModel, router: router, presentableControllerViewType: .navigationStack, persistentType: .taskList)
    }
}
