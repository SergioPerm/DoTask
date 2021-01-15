//
//  ShortcutListViewType.swift
//  Tasker
//
//  Created by KLuV on 14.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol ShortcutListViewType: PresentableController {
    var selectShortcutHandler: ((_: String) -> Void)? { get set }
}
