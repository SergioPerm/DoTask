//
//  TaskListCellFactoryType.swift
//  Tasker
//
//  Created by KLuV on 22.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

protocol TaskListCellFactoryType {
    var cellTypes: [TableViewCellType.Type] { get }
    func generateCell(viewModel: TaskListItemType, tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell
}
