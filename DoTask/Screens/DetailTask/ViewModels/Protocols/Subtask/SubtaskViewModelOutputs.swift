//
//  SubtaskViewModelOutputs.swift
//  DoTask
//
//  Created by KLuV on 22.12.2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import Foundation

protocol SubtaskViewModelOutputs {
    var isDone: Bool { get }
    var title: String { get }
    var priority: Int16 { get }
}
