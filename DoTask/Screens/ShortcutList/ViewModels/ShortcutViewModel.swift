//
//  ShortcutViewModel.swift
//  DoTask
//
//  Created by KLuV on 12.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

class ShortcutViewModel: ShortcutViewModelType, ShortcutViewModelOutputs {
    
    private var shortcut: Shortcut
    
    var outputs: ShortcutViewModelOutputs { return self }
    
    init(shortcut: Shortcut) {
        self.shortcut = shortcut
    }
    
    // MARK: Outputs
    
    var title: String {
        return shortcut.name
    }
    
    var color: String {
        return shortcut.color
    }
    
    var showInMainList: Bool {
        return shortcut.showInMainList
    }
    
    var uid: String {
        return shortcut.uid
    }

}
