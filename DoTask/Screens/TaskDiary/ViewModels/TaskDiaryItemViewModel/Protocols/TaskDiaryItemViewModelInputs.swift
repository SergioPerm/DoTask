//
//  TaskDiaryItemViewModelInputs.swift
//  DoTask
//
//  Created by KLuV on 04.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol TaskDiaryItemViewModelInputs {
    func unsetDone()
    func reuse(task: Task)
}
