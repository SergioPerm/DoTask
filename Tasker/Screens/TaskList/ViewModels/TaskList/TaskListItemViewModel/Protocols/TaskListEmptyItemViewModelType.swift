//
//  TaskListEmptyItemViewModelType.swift
//  Tasker
//
//  Created by KLuV on 22.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol TaskListEmptyItemViewModelType: class, TaskListItemType {
    var info: String { get }
    var rowHeight: Int { get }
}
