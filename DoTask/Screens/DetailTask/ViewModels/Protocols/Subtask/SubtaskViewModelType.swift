//
//  SubtaskViewModelType.swift
//  DoTask
//
//  Created by KLuV on 22.12.2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import Foundation

protocol SubtaskViewModelType: NSObject {
    var inputs: SubtaskViewModelInputs { get }
    var outputs: SubtaskViewModelOutputs { get }
}
