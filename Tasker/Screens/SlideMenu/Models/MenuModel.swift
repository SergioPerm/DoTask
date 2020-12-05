//
//  MenuModel.swift
//  Tasker
//
//  Created by kluv on 27/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import Foundation

struct TopItemModel {
    var imageName: String?
    var tapHandler: (() -> ())?
}

struct MainItemModel {
    var imageName: String?
    var title: String
    var tapHandler: (() -> ())?
}

struct ShortcutItemModel {
    var title: String
    var tapHandler: (() -> ())?
}

struct MenuModel {
    var topItem: TopItemModel
    var mainItems: [MainItemModel]
    var shortcutItems: [ShortcutItemModel]
}
