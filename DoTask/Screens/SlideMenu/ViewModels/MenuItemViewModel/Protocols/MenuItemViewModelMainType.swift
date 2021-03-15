//
//  MenuItemViewModelMainType.swift
//  DoTask
//
//  Created by KLuV on 09.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

enum MainMenuType {
    case mainList
    case diaryList
}

protocol MenuItemViewModelMainType {
    var title: String { get }
    var imageName: String { get }
    var menuType: MainMenuType { get }
}
