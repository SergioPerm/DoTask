//
//  MenuCellFactory.swift
//  Tasker
//
//  Created by KLuV on 09.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class MenuCellFactory: MenuCellFactoryType {
    
    var cellTypes: [TableViewCellType.Type] = [
        SettingsMenuTableViewCell.self,
        MainMenuTableViewCell.self,
        CreateShortcutMenuTableViewCell.self,
        ShortcutMenuTableViewCell.self,
        DiaryMenuTableViewCell.self
    ]
    
    func generateCell(viewModel: MenuItemViewModelType, tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        
        switch viewModel {
        case let viewModel as SettingsMenuItemViewModel:
            let view = SettingsMenuTableViewCell.reuse(tableView, for: indexPath)
            view.viewModel = viewModel
            return view
        case let viewModel as MainMenuItemViewModel:
            let view = MainMenuTableViewCell.reuse(tableView, for: indexPath)
            view.viewModel = viewModel
            return view
        case let viewModel as DiaryMenuItemViewModel:
            let view = DiaryMenuTableViewCell.reuse(tableView, for: indexPath)
            view.viewModel = viewModel
            return view
        case let viewModel as CreateShortcutMenuItemViewModel:
            let view = CreateShortcutMenuTableViewCell.reuse(tableView, for: indexPath)
            view.viewModel = viewModel
            return view
        case let viewModel as ShortcutMenuItemViewModel:
            let view = ShortcutMenuTableViewCell.reuse(tableView, for: indexPath)
            view.viewModel = viewModel
            return view
        default:
            return UITableViewCell()
        }
        
    }
    
}
