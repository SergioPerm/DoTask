//
//  DiaryMenuItemViewModel.swift
//  DoTask
//
//  Created by KLuV on 11.03.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

class DiaryMenuItemViewModel: MenuItemViewModelType, MenuItemViewModelMainType {
    
    var menuType: MainMenuType
    
    var rowHeight: Double = StyleGuide.SlideMenu.Sizes.bigRowHeight

    var title: String
    var imageName: String
    
    init(title: String, imageName: String, menuType: MainMenuType) {
        self.title = title
        self.imageName = imageName
        self.menuType = menuType
    }
    
}
