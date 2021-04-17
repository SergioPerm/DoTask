//
//  SettingsViewModel.swift
//  DoTask
//
//  Created by Сергей Лепинин on 05.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol SettingsViewModelInputs {
    func setLanguageHandler(handler: (() -> Void)?)
    func setTasksHandler(handler: (() -> Void)?)
    func setSpotlightHandler(handler: (() -> Void)?)
    func reloadData()
}

protocol SettingsViewModelOutputs {
    var settingsItems: [SettingsItemViewModelType] { get }
}

protocol SettingsViewModelType {
    var inputs: SettingsViewModelInputs { get }
    var outputs: SettingsViewModelOutputs { get }
}

class SettingsViewModel: SettingsViewModelType, SettingsViewModelOutputs, SettingsViewModelInputs {
    
    private let settingsService: SettingService
    
    private var languageHandler: (() -> Void)?
    private var tasksHandler: (() -> Void)?
    private var spotlightHandler: (() -> Void)?
    
    var inputs: SettingsViewModelInputs { return self }
    var outputs: SettingsViewModelOutputs { return self }
    
    init(settingsService: SettingService) {
        self.settingsService = settingsService
        loadData()
    }
    
    // MARK: Inputs:
    
    func setLanguageHandler(handler: (() -> Void)?) {
        languageHandler = handler
    }
    
    func setTasksHandler(handler: (() -> Void)?) {
        tasksHandler = handler
    }
    
    func setSpotlightHandler(handler: (() -> Void)?) {
        spotlightHandler = handler
    }
    
    func reloadData() {
        loadData()
    }
    
    // MARK: Outputs
    
    var settingsItems: [SettingsItemViewModelType] = []
    
}

extension SettingsViewModel {
    private func loadData() {
        
        settingsItems.removeAll()
        
        let settings = settingsService.getSettings()
        
        let languageSettings = SettingsMainItem(iconData: R.image.settings.language()!.pngData()!, title: LocalizableStringResource(stringResource: R.string.localizable.settings_LANGUAGE), singleValueItem: true, valueTitle: settings.language.getLocalize())
        
        let taskSettings = SettingsMainItem(iconData: R.image.settings.task()!.pngData()!, title: LocalizableStringResource(stringResource: R.string.localizable.settings_TASK), singleValueItem: false, valueTitle: nil)
        
        let spotlightValueLocalizeString = settings.spotlight ? LocalizableStringResource(stringResource: R.string.localizable.oN) : LocalizableStringResource(stringResource: R.string.localizable.ofF)
        
        let spotlightSettings = SettingsMainItem(iconData: R.image.settings.spotlight()!.pngData()!, title: LocalizableStringResource(stringResource: R.string.localizable.settings_SPOTLIGHT), singleValueItem: true, valueTitle: spotlightValueLocalizeString)
        
        
        settingsItems.append(SettingsItemViewModel(settingsItem: languageSettings, selectAction: { [weak self] in
            if let action = self?.languageHandler {
                action()
            }
        }))
        
        settingsItems.append(SettingsItemViewModel(settingsItem: taskSettings, selectAction: { [weak self] in
            if let action = self?.tasksHandler {
                action()
            }
        }))
        
        settingsItems.append(SettingsItemViewModel(settingsItem: spotlightSettings, selectAction: {
            //
        }))
        
    }
}
