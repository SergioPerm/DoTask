//
//  MenuCellType.swift
//  DoTask
//
//  Created by KLuV on 09.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

protocol TableViewCellType: UITableViewCell {
    static var identifier: String { get }
    static func register(_ tableView: UITableView)
    static func reuse(_ tableView: UITableView, for indexPath: IndexPath) -> Self
}

extension TableViewCellType {
    
    static var identifier: String {
        String(describing: self)
    }
    
    static func register(_ tableView: UITableView) {
        tableView.register(self, forCellReuseIdentifier: identifier)
    }
    
    static func reuse(_ tableView: UITableView, for indexPath: IndexPath) -> Self {
        tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! Self
    }
}
