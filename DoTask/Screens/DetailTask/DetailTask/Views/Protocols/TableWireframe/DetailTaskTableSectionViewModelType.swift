//
//  EditTaskTableSectionViewModelType.swift
//  DoTask
//
//  Created by KLuV on 31.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol DetailTaskTableSectionViewModelType {
    var sectionHeight: Double { get }
    var tableCells: [DetailTaskTableItemViewModelType] { get set }
}
