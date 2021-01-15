//
//  ShortcutListDataSource.swift
//  Tasker
//
//  Created by KLuV on 07.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol ShortcutListDataSource {
    var shortcuts: [Shortcut] { get }
    var observer: ShortcutListDataSourceObserver? { get set }

    func addShortcut(for shortcut: Shortcut)
    func updateShortcut(for shortcut: Shortcut)
    func deleteShortcut(for shortcut: Shortcut)
    
    func shortcutByIdentifier(identifier: String?) -> Shortcut?
    
    func clearData()
}
