//
//  MenuItemSectionViewModelType.swift
//  Tasker
//
//  Created by KLuV on 09.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol MenuItemSectionViewModelType {
    var tableCells: [MenuItemViewModelType] { get set }
    var sectionHeight: Double { get }
}
