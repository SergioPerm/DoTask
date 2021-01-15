//
//  ShortcutListViewModelType.swift
//  Tasker
//
//  Created by KLuV on 12.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol ShortcutListViewModelType {
    var inputs: ShortcutListViewModelInputs { get }
    var outputs: ShortcutListViewModelOutputs { get }
}
