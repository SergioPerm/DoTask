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
        container.register(SettingsViewModel.init(settingsService:))
            .as(SettingsViewModelType.self)
        
        container.register{
            SettingsViewController(viewModel: $0, router: $1, presentableControllerViewType: .navigationStack)
        }.as(SettingsViewType.self)
                
        container.register(SettingsLanguageViewModel.init(settingsService:localizeService:))
            .as(SettingsLanguageViewModelType.self)
        
        container.register{
            SettingsLanguageViewController(viewModel: $0, router: $1, presentableControllerViewType: .navigationStack)
        }.as(SettingsLanguageViewType.self)
    }
}

