//
//  MenuItemViewModelShortcutType.swift
//  Tasker
//
//  Created by KLuV on 09.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol MenuItemViewModelShortcutType {
    var shortcut: Shortcut { get }
    func reuse(for shortcut: Shortcut)
}
