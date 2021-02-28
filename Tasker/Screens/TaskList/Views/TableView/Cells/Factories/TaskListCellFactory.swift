//
//  TaskListCellFactory.swift
//  Tasker
//
//  Created by KLuV on 22.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class TaskListCellFactory: TaskListCellFactoryType {
    
    var cellTypes: [TableViewCellType.Type] = [
        TaskListTableViewCell.self,
        TaskListEmptyTableViewCell.self
    ]
    
    func generateCell(viewModel: TaskListItemType, tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        
        switch viewModel {
        case let viewModel as TaskListItemViewModelType:
            let view = TaskListTableViewCell.reuse(tableView, for: indexPath)
            view.viewModel = viewModel
            return view
        case let viewModel as TaskListEmptyItemViewModelType:
            let view = TaskListEmptyTableViewCell.reuse(tableView, for: indexPath)
            view.viewModel = viewModel
            return view
        default:
            return UITableViewCell()
        }
        
    }
    
}
