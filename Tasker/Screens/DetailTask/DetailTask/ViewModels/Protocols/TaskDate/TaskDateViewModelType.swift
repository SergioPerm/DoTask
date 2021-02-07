//
//  TaskDateInfoViewModelType.swift
//  Tasker
//
//  Created by KLuV on 31.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol TaskDateViewModelType: class {
    var inputs: TaskDateViewModelInputs { get }
    var outputs: TaskDateViewModelOutputs { get }
}
