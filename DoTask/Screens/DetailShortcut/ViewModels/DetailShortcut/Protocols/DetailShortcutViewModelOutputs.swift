//
//  DetailShortcutViewModelOutputs.swift
//  DoTask
//
//  Created by KLuV on 05.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

protocol DetailShortcutViewModelOutputs {
    var selectedColor: Observable<String> { get }
    var title: String { get }
    var isNew: Bool { get }
    var showInMainListSetting: Bool { get }
    func getAllColors() -> [ColorSelectionItemViewModelType]
}
