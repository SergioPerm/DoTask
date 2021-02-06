//
//  TaskDateInfoViewModelType.swift
//  Tasker
//
//  Created by KLuV on 31.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol TaskDateInfoViewModelType: class {
    var inputs: TaskDateInfoViewModelInputs { get }
    var outputs: TaskDateInfoViewModelOutputs { get }
}
