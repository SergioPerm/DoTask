//
//  DetailShortcutViewModelOutputs.swift
//  DoTask
//
//  Created by KLuV on 05.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

protocol DetailShortcutViewModelOutputs {
    var selectedColor: Boxing<UIColor?> { get }
    var title: String { get }
    var isNew: Bool { get }
    var showInMainListSetting: Bool { get }
    func getAllColors() -> [UIColor]
}
