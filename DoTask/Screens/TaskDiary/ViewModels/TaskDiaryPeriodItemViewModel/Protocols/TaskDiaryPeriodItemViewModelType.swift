//
//  TaskDiaryPeriodItemViewModelType.swift
//  DoTask
//
//  Created by KLuV on 04.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol TaskDiaryPeriodItemViewModelType {
    var title: String { get }
    var tasks: [TaskDiaryItemViewModelType] { get set }
}
