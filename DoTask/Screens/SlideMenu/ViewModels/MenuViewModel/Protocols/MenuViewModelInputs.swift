//
//  MenuShortcutListViewModelInputs.swift
//  DoTask
//
//  Created by KLuV on 07.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol MenuViewModelInputs: AnyObject {
    var createShortcutHandler: (() -> Void)? { get set }
    var shortcutTableView: ShortcutListTableViewType? { get set }
    func deleteShortcut(for shortcut: Shortcut)
    func selectItem(for indexPath: IndexPath)
}
