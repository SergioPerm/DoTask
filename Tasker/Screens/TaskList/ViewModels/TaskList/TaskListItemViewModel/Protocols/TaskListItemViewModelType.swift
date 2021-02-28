//
//  TaskListItemViewModelType.swift
//  Tasker
//
//  Created by KLuV on 27.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol TaskListItemViewModelType: TaskListItemType {
    var inputs: TaskListItemViewModelInputs { get }
    var outputs: TaskListItemViewModelOutputs { get }
}

