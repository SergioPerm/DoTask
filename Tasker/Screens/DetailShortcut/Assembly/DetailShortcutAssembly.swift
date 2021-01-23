//
//  DetailShortcutAssembly.swift
//  Tasker
//
//  Created by KLuV on 05.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class DetailShortcutAssembly {
    static func createInstance(shortcutUID: String?, presenter: RouterType?) -> DetailShortcutViewController {
        let dataSource: ShortcutListDataSource = ShortcutListDataSourceCoreData(context: CoreDataService.shared.context)
        let viewModel = DetailShortcutViewModel(shortcutUID: shortcutUID, dataSource: dataSource)
        
        let vc = DetailShortcutViewController(viewModel: viewModel, presenter: presenter, presentableControllerViewType: .presentWithTransition)
                
        return vc
    }
}
