//
//  DetailTaskDependency.swift
//  DoTask
//
//  Created by Сергей Лепинин on 01.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation
import DITranquillity

class DetailTaskDependency: DIPart {
    static func load(container: DIContainer) {
        
        container.register(DetailTaskViewModel.init(dataSource:spotlightService:))
            .as(DetailTaskViewModelType.self)
            .lifetime(.prototype)
        
        container.register {
            DetailTaskNewViewController(viewModel: $0, router: $1, presentableControllerViewType: .presentWithTransition)
        }.as(DetailTaskViewType.self, tag: DetailTaskNewViewController.self).lifetime(.prototype)
        
        container.register {
            DetailTaskEditViewController(viewModel: $0, router: $1, presentableControllerViewType: .presentWithTransition)
        }.as(DetailTaskViewType.self, tag: DetailTaskEditViewController.self).lifetime(.prototype)
        
    }
}


