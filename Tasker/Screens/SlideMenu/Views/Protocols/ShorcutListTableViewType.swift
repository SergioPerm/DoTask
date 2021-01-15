//
//  ShorcutListTableViewType.swift
//  Tasker
//
//  Created by KLuV on 07.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol ShortcutListTableViewType {
    func tableViewReload()
    func tableViewBeginUpdates()
    func tableViewEndUpdates()
    func tableViewInsertRow(at newIndexPath: IndexPath)
    func tableViewDeleteRow(at indexPath: IndexPath)
    func tableViewUpdateRow(at indexPath: IndexPath)
}
