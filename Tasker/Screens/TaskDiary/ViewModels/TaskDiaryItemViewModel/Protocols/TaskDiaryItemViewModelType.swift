//
//  TaskDiaryItemViewModelType.swift
//  Tasker
//
//  Created by KLuV on 04.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol TaskDiaryItemViewModelType {
    var inputs: TaskDiaryItemViewModelInputs { get }
    var outputs: TaskDiaryItemViewModelOutputs { get }
}
