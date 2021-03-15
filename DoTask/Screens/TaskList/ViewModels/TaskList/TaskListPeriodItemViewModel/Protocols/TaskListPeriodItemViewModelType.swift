//
//  TaskListDailyItemViewModelType.swift
//  DoTask
//
//  Created by KLuV on 27.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol TaskListPeriodItemViewModelType {
    //var title: String { get }
    //var tasks: [TaskListItemViewModelType] { get set }
    var inputs: TaskListPeriodItemViewModelInputs { get }
    var outputs: TaskListPeriodItemViewModelOutputs { get }
}
