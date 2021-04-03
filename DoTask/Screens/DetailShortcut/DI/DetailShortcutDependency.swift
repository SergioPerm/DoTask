//
//  DetailShortcutDependency.swift
//  DoTask
//
//  Created by Сергей Лепинин on 01.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation
import DITranquillity

class DetailShortcutDependency: DIPart {
    static func load(container: DIContainer) {        
        container.register(DetailShortcutViewModel.init(dataSource:))
            .as(DetailShortcutViewModelType.self)
            .lifetime(.prototype)
                
        container.register {
            DetailShortcutViewController(viewModel: $0, router: $1, presentableControllerViewType: .presentWithTransition)
        }.as(DetailShortcutViewType.self).lifetime(.prototype)
    }
}
