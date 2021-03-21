//
//  CreateShortcutMenuItemViewModel.swift
//  DoTask
//
//  Created by KLuV on 09.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

class CreateShortcutMenuItemViewModel: MenuItemViewModelType, MenuItemViewModelCreateShortcutType {
    
    var rowHeight: Double = StyleGuide.SlideMenu.Sizes.midRowHeight
    var createShortcutHandler: (() -> Void)?
            
    func createShortcut() {
        if let createShortcutAction = createShortcutHandler {
            createShortcutAction()
        }
    }
    
}
