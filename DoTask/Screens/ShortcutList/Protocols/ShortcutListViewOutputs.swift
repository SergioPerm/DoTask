//
//  ShortcutListViewOutputs.swift
//  DoTask
//
//  Created by KLuV on 12.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol ShortcutListViewOutputs: AnyObject {
    var selectedShortcutUID: String? { get set }
}
