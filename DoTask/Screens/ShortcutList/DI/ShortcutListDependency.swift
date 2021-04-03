//
//  ShortcutListDependency.swift
//  DoTask
//
//  Created by Сергей Лепинин on 02.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation
import DITranquillity

class ShortcutListDependency: DIPart {
    static func load(container: DIContainer) {
        container.register(ShortcutListViewModel.init(dataSource:))
            .as(ShortcutListViewModelType.self).lifetime(.prototype)
        
        container.register {
            ShortcutListViewController(viewModel: $0, presenter: $1, presentableControllerViewType: .presentWithTransition)
        }.as(ShortcutListViewType.self).lifetime(.prototype)
    }
}
