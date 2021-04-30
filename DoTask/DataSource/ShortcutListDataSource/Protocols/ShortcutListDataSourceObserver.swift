//
//  ShortcutListDataSourceObserver.swift
//  DoTask
//
//  Created by KLuV on 07.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol ShortcutListDataSourceObserver: AnyObject {
    func shortcutWillChange()
    func shortcutDidChange()
    func shortcutInserted(at newIndexPath: IndexPath)
    func shortcutDeleted(at indexPath: IndexPath)
    func shortcutUpdated(at indexPath: IndexPath)
}
