//
//  SettingsMainCellFactory.swift
//  DoTask
//
//  Created by Sergio Lechini on 07.07.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

/// For next update Feedback info

//protocol SettingsMainCellFactoryType {
//    var cellTypes: [TableViewCellType.Type] { get }
//    func generateCell(viewModel: SettingsMenuItemViewModel, tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell
//}
//
//final class SettingsMainCellFactory: SettingsMainCellFactoryType {
//
//    var cellTypes: [TableViewCellType.Type] = [
//        SettingsMenuTableViewCell.self
//    ]
//
//    func generateCell(viewModel: SettingsMenuItemViewModel, tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
//
//        switch viewModel {
//        case let viewModel as SettingsItemViewModelType:
//            let view = SettingsMenuTableViewCell.reuse(tableView, for: indexPath)
//            view.viewModel = viewModel
//            return view
////        case let viewModel as TaskListEmptyItemViewModelType:
////            let view = TaskListEmptyTableViewCell.reuse(tableView, for: indexPath)
////            view.viewModel = viewModel
////            return view
//        default:
//            return UITableViewCell()
//        }
//
//    }
//
//}
