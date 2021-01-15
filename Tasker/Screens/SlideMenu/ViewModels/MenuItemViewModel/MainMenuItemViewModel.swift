//
//  MainMenuItemViewModel.swift
//  Tasker
//
//  Created by KLuV on 08.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

class MainMenuItemViewModel: MenuItemViewModelType, MenuItemViewModelMainType, MenuItemViewModelSelectableType {
    
    var rowHeight: Double = 50
    var selectedItem: Bool
    
    var title: String
    var imageName: String
    
    init(title: String, imageName: String, selected: Bool = false) {
        self.title = title
        self.imageName = imageName
        self.selectedItem = selected
    }
    
}
