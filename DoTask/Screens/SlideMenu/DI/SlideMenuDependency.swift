//
//  SlideMenuDependency.swift
//  DoTask
//
//  Created by Сергей Лепинин on 01.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation
import DITranquillity

final class SlideMenuDependency: DIPart {
    
    static func load(container: DIContainer) {
                
        container.register(MenuViewModel.init(dataSource:))
            .as(MenuViewModelType.self)
            .lifetime(.prototype)
        
        container.register {
            MenuViewController(viewModel: $0, presenter: $1, presentableControllerViewType: .containerChild)
        }.as(SlideMenuViewType.self).lifetime(.perRun(.weak))
                
    }

}
