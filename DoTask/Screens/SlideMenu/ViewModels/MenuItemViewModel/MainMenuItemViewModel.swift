//
//  MainMenuItemViewModel.swift
//  DoTask
//
//  Created by KLuV on 08.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

class MainMenuItemViewModel: MenuItemViewModelType, MenuItemViewModelMainType, MenuItemViewModelSelectableType {
    
    var menuType: MainMenuType
    
    var selectedItem: Observable<Bool>
    var rowHeight: Double = StyleGuide.SlideMenu.Sizes.bigRowHeight

    var title: LocalizableStringResource
    var imageName: String
    
    init(title: LocalizableStringResource, imageName: String, selected: Bool = false, menuType: MainMenuType) {
        self.title = title
        self.imageName = imageName
        self.selectedItem = Observable(selected)
        self.menuType = menuType
    }
    
}
