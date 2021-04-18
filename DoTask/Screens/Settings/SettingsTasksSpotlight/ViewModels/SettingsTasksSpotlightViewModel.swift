//
//  SettingsTasksSpotlightViewModel.swift
//  DoTask
//
//  Created by Сергей Лепинин on 18.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol SettingsTasksSpotlightViewModelInputs {
    func changeSpotlightSetting()
}

protocol SettingsTasksSpotlightViewModelOutputs {
    var spotlight: Bool { get }
}

protocol SettingsTasksSpotlightViewModelType {
    var inputs: SettingsTasksSpotlightViewModelInputs { get }
    var outputs: SettingsTasksSpotlightViewModelOutputs { get }
}

class SettingsTasksSpotlightViewModel: SettingsTasksSpotlightViewModelType, SettingsTasksSpotlightViewModelInputs, SettingsTasksSpotlightViewModelOutputs {
    
    private let settingsService: SettingService
    private var currentSettings: SettingService.Settings
    
    var inputs: SettingsTasksSpotlightViewModelInputs { return self }
    var outputs: SettingsTasksSpotlightViewModelOutputs { return self }
    
    init(settingsService: SettingService) {
        self.settingsService = settingsService
        currentSettings = settingsService.getSettings()
    }
    
    // MARK: Inputs
    
    func changeSpotlightSetting() {
        currentSettings.spotlight = !currentSettings.spotlight
        settingsService.saveSettings(settings: currentSettings)
    }
    
    // MARK: Outputs
    
    var spotlight: Bool {
        currentSettings.spotlight
    }
}
