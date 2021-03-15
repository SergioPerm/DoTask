//
//  DetailTaskCellFactoryType.swift
//  DoTask
//
//  Created by KLuV on 31.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

protocol DetailTaskCellFactoryType {
    var cellTypes: [DetailTaskCellType.Type] { get }
    func generateCell(viewModel: DetailTaskTableItemViewModelType, tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell
}
