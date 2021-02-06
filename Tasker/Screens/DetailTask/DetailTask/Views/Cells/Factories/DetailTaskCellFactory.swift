//
//  DetailTaskCellFactory.swift
//  Tasker
//
//  Created by KLuV on 31.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class DetailTaskCellFactory: DetailTaskCellFactoryType {
    
    var cellTypes: [DetailTaskCellType.Type] = [
        SubtaskTableViewCell.self,
        TaskDateInfoTableViewCell.self,
        TaskReminderInfoTableViewCell.self
    ]
    
    func generateCell(viewModel: DetailTaskTableItemViewModelType, tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        
        switch viewModel {
        case let viewModel as SubtaskViewModelType:
            let view = SubtaskTableViewCell.reuse(tableView, for: indexPath)
            view.subtaskViewModel = viewModel
                        
            return view
        case let viewModel as TaskDateInfoViewModelType:
            let view = TaskDateInfoTableViewCell.reuse(tableView, for: indexPath)
            view.viewModel = viewModel
            return view
        case let viewModel as TaskReminderInfoViewModelType:
            let view = TaskReminderInfoTableViewCell.reuse(tableView, for: indexPath)
            view.viewModel = viewModel
            return view
        default:
            return UITableViewCell()
        }
        
    }
    
}
