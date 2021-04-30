//
//  SettingsViewType.swift
//  DoTask
//
//  Created by Сергей Лепинин on 06.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

protocol SettingsViewType: PresentableController {
    var navDelegate: UINavigationControllerDelegate? { get set }
    
    var settingLanguageHandler: (() -> Void)? { get set }
    var settingTasksHandler: (() -> Void)? { get set }
    var settingSpotlightHandler: (() -> Void)? { get set }
}
