//
//  AppDependency.swift
//  DoTask
//
//  Created by Сергей Лепинин on 01.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit
import DITranquillity

class AppDependency: DIPart {
    static func load(container: DIContainer) {
        
        container.register {
            Router(rootViewController: UIViewController())
        }.as(RouterType.self).lifetime(.perContainer(.weak))
        
        container.register(MainCoordinator.init(presenter:))
        
        container.register(LocalizeService.init)
            .as(LocalizeServiceType.self).as(LocalizeServiceSettingsType.self).lifetime(.perRun(.strong))
        
        container.register(SettingService.init).lifetime(.perRun(.strong))
               
    }
}
