//
//  TaskListEmptyItemViewModelType.swift
//  DoTask
//
//  Created by KLuV on 22.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol TaskListEmptyItemViewModelType: AnyObject, TaskListItemType {
    var info: LocalizableStringResource? { get }
    var rowHeight: Int { get }
}
