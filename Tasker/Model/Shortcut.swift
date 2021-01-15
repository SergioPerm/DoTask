//
//  Shortcut.swift
//  Tasker
//
//  Created by KLuV on 05.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

struct Shortcut {
    var uid: String
    var name: String
    var color: String
    var showInMainList: Bool
    var isNew: Bool = false

    init() {
        self.uid = UUID().uuidString
        self.name = ""
        self.color = ""
        self.showInMainList = true
        self.isNew = true
    }
    
    init(with managedObject: ShortcutManaged) {
        self.uid = managedObject.identificator.uuidString
        self.name = managedObject.name
        self.color = managedObject.color
        self.showInMainList = managedObject.showInMainList
    }
}
