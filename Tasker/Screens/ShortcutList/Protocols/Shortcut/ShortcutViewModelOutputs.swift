//
//  ShortcutViewModelOutputs.swift
//  Tasker
//
//  Created by KLuV on 12.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol ShortcutViewModelOutputs {
    var title: String { get }
    var color: String { get }
    var showInMainList: Bool { get }
    var uid: String { get }
}
