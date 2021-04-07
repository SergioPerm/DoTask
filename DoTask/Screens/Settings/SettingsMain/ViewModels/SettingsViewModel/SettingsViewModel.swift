//
//  SettingsViewModel.swift
//  DoTask
//
//  Created by Сергей Лепинин on 05.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol SettingsViewModelOutputs {
    var settingsItems: [SettingsItemViewModelType] { get }
}

protocol SettingsViewModelType {
    var outputs: SettingsViewModelOutputs { get }
}

class SettingsViewModel: SettingsViewModelType, SettingsViewModelOutputs {
    
    private let settingsService: SettingService
    
    var outputs: SettingsViewModelOutputs { return self }
    
    init(settingsService: SettingService) {
        self.settingsService = settingsService
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
        
        
        settingsItems.append(SettingsItemViewModel(settingsItem: languageSettings, selectAction: {
            // open language vc
        }))
        
        settingsItems.append(SettingsItemViewModel(settingsItem: taskSettings, selectAction: {
            //
        }))
        
        settingsItems.append(SettingsItemViewModel(settingsItem: spotlightSettings, selectAction: {
            //
        }))
        
    }
}
