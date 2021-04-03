//
//  TaskDiaryDependency.swift
//  DoTask
//
//  Created by Сергей Лепинин on 02.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation
import DITranquillity

class TaskDiaryDependency: DIPart {
    static func load(container: DIContainer) {
        
        container.register(TaskDiaryViewModel.init(dataSource:))
            .as(TaskDiaryViewModelType.self).lifetime(.prototype)
        
        container.register {
            TaskDiaryNavigationController(viewModel: $0, router: $1, presentableControllerViewType: .presentWithTransition, persistentType: .none)
        }.as(TaskDiaryViewPresentable.self).lifetime(.prototype)
        
    }
}
