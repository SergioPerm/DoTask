//
//  DetailTaskViewModelType.swift
//  DoTask
//
//  Created by kluv on 21/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import Foundation

protocol DetailTaskViewModelType: AnyObject {
    var inputs: DetailTaskViewModelInputs { get }
    var outputs: DetailTaskViewModelOutputs { get }
}
