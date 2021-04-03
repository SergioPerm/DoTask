//
//  TaskListDependency.swift
//  DoTask
//
//  Created by Сергей Лепинин on 01.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation
import DITranquillity

class TaskListDependency: DIPart {
    static func load(container: DIContainer) {
        
        container.register(TaskListViewModel.init(dataSource:))
            .as(TaskListViewModelType.self)
            .lifetime(.prototype)
                
        container.register {
            TaskListViewController(viewModel: $0, router: $1, presentableControllerViewType: .navigationStack, persistentType: .taskList)
        }.as(TaskListViewType.self).lifetime(.perRun(.weak))
        
    }
}
