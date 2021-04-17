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
        
        //Main settings
        container.register(SettingsViewModel.init(settingsService:))
            .as(SettingsViewModelType.self)
        
        container.register{
            SettingsViewController(viewModel: $0, router: $1, presentableControllerViewType: .navigationStack)
        }.as(SettingsViewType.self)
                
        //Languages
        container.register(SettingsLanguageViewModel.init(settingsService:localizeService:))
            .as(SettingsLanguageViewModelType.self)
        
        container.register{
            SettingsLanguageViewController(viewModel: $0, router: $1, presentableControllerViewType: .navigationStack)
        }.as(SettingsLanguageViewType.self)
        
        //Tasks
        container.register(SettingsTasksViewModel.init(settingsService:shortcutDataSource:))
            .as(SettingsTasksViewModelType.self)
        
        container.register({
            SettingsTasksViewController.init(viewModel: $0, router: $1, presentableControllerViewType: .navigationStack)
        }).as(SettingsTasksViewType.self)
        
        //Task new time
        container.register(SettingsTasksNewTimeViewModel.init(settingsService:))
            .as(SettingsTasksNewTimeViewModelType.self)
        
        container.register({
            SettingsTasksNewTimeViewController(viewModel: $0, router: $1, presentableControllerViewType: .navigationStack)
        }).as(SettingsTasksNewTimeViewType.self)
        
        //Default shortcut
        container.register(SettingsTasksShortcutViewModel.init(settingsService:shortcutDataSource:))
            .as(SettingsTasksShortcutViewModelType.self)
        
        container.register({
            SettingsTasksShortcutViewController(viewModel: $0, router: $1, presentableControllerViewType: .navigationStack)
        }).as(SettingsTasksShortcutViewType.self)
    }
}

