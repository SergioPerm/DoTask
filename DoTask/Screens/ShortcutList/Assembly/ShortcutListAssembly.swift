//
//  ShortcutListAssembly.swift
//  DoTask
//
//  Created by KLuV on 14.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

class ShortcutListAssembly {
    static func createInstance(presenter: RouterType?) -> ShortcutListViewType {
        let dataSource = ShortcutListDataSourceCoreData(context: CoreDataService.shared.context)
        let viewModel = ShortcutListViewModel(dataSource: dataSource)
        
        return ShortcutListViewController(viewModel: viewModel, presenter: presenter, presentableControllerViewType: .presentWithTransition)
    }
}