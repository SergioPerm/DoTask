//
//  SettingsTasksShowDoneViewModel.swift
//  DoTask
//
//  Created by Сергей Лепинин on 18.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol SettingsTasksShowDoneViewModelInputs {
    func changeShowDoneSetting()
}

protocol SettingsTasksShowDoneViewModelOutputs {
    var showDone: Bool { get }
}

protocol SettingsTasksShowDoneViewModelType {
    var inputs: SettingsTasksShowDoneViewModelInputs { get }
    var outputs: SettingsTasksShowDoneViewModelOutputs { get }
}

class SettingsTasksShowDoneViewModel: SettingsTasksShowDoneViewModelType, SettingsTasksShowDoneViewModelInputs, SettingsTasksShowDoneViewModelOutputs {
    
    private let settingsService: SettingService
    private var currentSettings: SettingService.Settings
    
    var inputs: SettingsTasksShowDoneViewModelInputs { return self }
    var outputs: SettingsTasksShowDoneViewModelOutputs { return self }
    
    init(settingsService: SettingService) {
        self.settingsService = settingsService
        currentSettings = settingsService.getSettings()
    }
    
    // MARK: Inputs
    
    func changeShowDoneSetting() {
        currentSettings.task.showDoneTasksInToday = !currentSettings.task.showDoneTasksInToday
        settingsService.saveSettings(settings: currentSettings)
    }
    
    // MARK: Outputs
    
    var showDone: Bool {
        currentSettings.task.showDoneTasksInToday
    }
}
