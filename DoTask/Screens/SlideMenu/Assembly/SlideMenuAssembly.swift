//
//  SlideMenuAssembly.swift
//  DoTask
//
//  Created by KLuV on 03.12.2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import Foundation

class SlideMenuAssembly {
    static func createInstance(router: RouterType?) -> SlideMenuViewType {
        
        let dataSource: ShortcutListDataSource = ShortcutListDataSourceCoreData(context: CoreDataService.shared.context)
        let viewModel = MenuViewModel(dataSource: dataSource)
        
        let vc = MenuViewController(viewModel: viewModel, presenter: router, presentableControllerViewType: .slideMenu)
        
        return vc
    }
}
