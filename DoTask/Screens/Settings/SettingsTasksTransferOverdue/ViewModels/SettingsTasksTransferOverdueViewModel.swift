//
//  SettingsTasksTransferOverdueViewModel.swift
//  DoTask
//
//  Created by Сергей Лепинин on 18.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol SettingsTasksTransferOverdueViewModelInputs {
    func changeTransferOverdueSetting()
}

protocol SettingsTasksTransferOverdueViewModelOutputs {
    var transferOverdue: Bool { get }
}

protocol SettingsTasksTransferOverdueViewModelType {
    var inputs: SettingsTasksTransferOverdueViewModelInputs { get }
    var outputs: SettingsTasksTransferOverdueViewModelOutputs { get }
}

class SettingsTasksTransferOverdueViewModel: SettingsTasksTransferOverdueViewModelType, SettingsTasksTransferOverdueViewModelInputs, SettingsTasksTransferOverdueViewModelOutputs {
    
    private let dataSource: TasksMaintainceDataSource = AppDI.resolve()
    
    private let settingsService: SettingService
    private var currentSettings: SettingService.Settings
    
    var inputs: SettingsTasksTransferOverdueViewModelInputs { return self }
    var outputs: SettingsTasksTransferOverdueViewModelOutputs { return self }
    
    init(settingsService: SettingService) {
        self.settingsService = settingsService
        currentSettings = settingsService.getSettings()
    }
    
    // MARK: Inputs
    
    func changeTransferOverdueSetting() {
        currentSettings.task.transferOverdueTasksToToday = !currentSettings.task.transferOverdueTasksToToday
        settingsService.saveSettings(settings: currentSettings)
        
        if currentSettings.task.transferOverdueTasksToToday {
            dataSource.transferOverdueTasks()
        }
    }
    
    // MARK: Outputs
    
    var transferOverdue: Bool {
        currentSettings.task.transferOverdueTasksToToday
    }
}
