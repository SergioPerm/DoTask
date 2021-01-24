//
//  MenuShortcutListViewModelInputs.swift
//  Tasker
//
//  Created by KLuV on 07.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol MenuViewModelInputs: class {
    var createShortcutHandler: (() -> Void)? { get set }
    var shortcutTableView: ShortcutListTableViewType? { get set }
    func deleteShortcut(for shortcut: Shortcut)
    func selectShortcut(for indexPath: IndexPath)
}
