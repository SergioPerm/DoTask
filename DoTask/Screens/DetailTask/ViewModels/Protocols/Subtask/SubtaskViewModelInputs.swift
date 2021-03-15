//
//  SubtaskViewModelInputs.swift
//  DoTask
//
//  Created by KLuV on 22.12.2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import Foundation

protocol SubtaskViewModelInputs {
    func setDone(done: Bool)
    func setTitle(title: String)
    func setPriority(priority: Int16)
}
