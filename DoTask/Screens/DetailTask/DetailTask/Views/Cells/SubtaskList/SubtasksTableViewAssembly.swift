//
//  SubtasksTableViewAssembly.swift
//  Tasker
//
//  Created by KLuV on 23.12.2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

class SubtasksTableViewAssembly {
    static func createInstance(subtasks: [SubtaskViewModelType], parentScrollView: UIScrollView, lowerLimitToScroll: CGFloat) -> UITableView {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(SubtaskTableViewCell.self, forCellReuseIdentifier: SubtaskTableViewCell.className)
        tableView.separatorStyle = .none
        
        tableView.tableFooterView = SubtasksFooterView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 33))
        
        let dataSource = SubtasksTableViewDataSource(subtasks: subtasks, parentScrollView: parentScrollView, lowerLimitToScroll: lowerLimitToScroll)
        let delegate = SubtasksTableViewDelegate()
        
        tableView.dataSource = dataSource
        tableView.delegate = delegate
        
        return tableView
    }
}
