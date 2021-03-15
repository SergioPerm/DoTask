//
//  TaskListViewModelType.swift
//  DoTask
//
//  Created by KLuV on 27.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol TaskListViewModelType {
    var inputs: TaskListViewModelInputs { get }
    var outputs: TaskListViewModelOutputs { get }
}
