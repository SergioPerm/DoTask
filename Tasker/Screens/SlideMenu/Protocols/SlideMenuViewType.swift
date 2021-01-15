//
//  SlideMenuViewType.swift
//  Tasker
//
//  Created by KLuV on 05.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol SlideMenuViewType: PresentableController {
    var openSettingsHandler: ((_ menu: SlideMenuViewType?) -> Void)? { get set }
    var openTaskListHandler: ((_ menu: SlideMenuViewType?) -> Void)? { get set }
    var openDetailShortcutHandler: ((_ shortcutUID: String?) -> Void)? { get set }
    func toggleMenu()
    var parentController: MenuParentControllerType? { get set }
    var enabled: Bool { get set }
}
