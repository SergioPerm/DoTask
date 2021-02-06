//
//  DetailTaskTableSectionViewModel.swift
//  Tasker
//
//  Created by KLuV on 31.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

class DetailTaskTableSectionViewModel: DetailTaskTableSectionViewModelType {
    
    var sectionHeight: Double
    var tableCells: [DetailTaskTableItemViewModelType]
    
    init(cells: [DetailTaskTableItemViewModelType], sectionHeight: Double) {
        self.tableCells = cells
        self.sectionHeight = sectionHeight
    }
}
