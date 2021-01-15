//
//  MenuSectionViewModel.swift
//  Tasker
//
//  Created by KLuV on 09.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation 

class MenuItemSectionViewModel: MenuItemSectionViewModelType {
    
    var sectionHeight: Double
    var tableCells: [MenuItemViewModelType]
    
    init(cells: [MenuItemViewModelType], sectionHeight: Double) {
        self.tableCells = cells
        self.sectionHeight = sectionHeight
    }
}
