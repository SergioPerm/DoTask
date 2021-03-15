//
//  MenuCellFactoryType.swift
//  DoTask
//
//  Created by KLuV on 09.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

protocol MenuCellFactoryType {
    var cellTypes: [TableViewCellType.Type] { get }
    func generateCell(viewModel: MenuItemViewModelType, tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell
}
