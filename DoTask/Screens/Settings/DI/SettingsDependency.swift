//
//  SettingsMainDependency.swift
//  DoTask
//
//  Created by Сергей Лепинин on 02.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation
import DITranquillity

class SettingsDependency: DIPart {
    static func load(container: DIContainer) {
        container.register{
            SettingsViewController(router: $0, presentableControllerViewType: .navigationStack)
        }
    }
}

