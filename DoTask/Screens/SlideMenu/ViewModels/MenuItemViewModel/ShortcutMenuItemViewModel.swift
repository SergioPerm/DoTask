//
//  ShortcutMenuItemViewModel.swift
//  DoTask
//
//  Created by KLuV on 09.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

class ShortcutMenuItemViewModel: MenuItemViewModelType, MenuItemViewModelSelectableType, MenuItemViewModelShortcutType {
    
    var rowHeight: Double = 40
    var shortcut: Shortcut
    var selectedItem: Observable<Bool>
    
    init(shortcut: Shortcut, selected: Bool = false) {
        self.shortcut = shortcut
        self.selectedItem = Observable(selected)
    }
    
    func reuse(for shortcut: Shortcut) {
        self.shortcut = shortcut
    }
    
}
