//
//  SettingsTasksViewType.swift
//  DoTask
//
//  Created by Сергей Лепинин on 15.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol SettingsTasksViewType: PresentableController {
    var settingNewTaskTimeHandler: (() -> Void)? { get set }
    var settingDefaultShortcutHandler: (() -> Void)? { get set }
    var settingShowCompletedTasksHandler: (() -> Void)? { get set }
    var settingTransferOverdueHandler: (() -> Void)? { get set }
}

