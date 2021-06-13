//
//  DetailShortcutViewType.swift
//  DoTask
//
//  Created by Сергей Лепинин on 01.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol DetailShortcutViewType: PresentableController {
    var shortcutUID: String? { get set }
    var openMainTaskListHandler: (() -> ())? { get set }
}
