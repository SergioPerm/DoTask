//
//  SettingsTasksNewTimeViewModel.swift
//  DoTask
//
//  Created by Сергей Лепинин on 15.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol SettingsTasksNewTimeViewModelInputs {
    func setSelected(index: Int)
}

protocol SettingsTasksNewTimeViewModelOutputs {
    var items: [SettingsTasksNewTimeItemViewModelType] { get }
}

protocol SettingsTasksNewTimeViewModelType {
    var inputs: SettingsTasksNewTimeViewModelInputs { get }
    var outputs: SettingsTasksNewTimeViewModelOutputs { get }
}

class SettingsTasksNewTimeViewModel: SettingsTasksNewTimeViewModelType, SettingsTasksNewTimeViewModelInputs, SettingsTasksNewTimeViewModelOutputs {
        
    private let settingsService: SettingService
    private var currentSettings: SettingService.Settings
    
    var inputs: SettingsTasksNewTimeViewModelInputs { return self }
    var outputs: SettingsTasksNewTimeViewModelOutputs { return self }
    
    init(settingsService: SettingService) {
        self.settingsService = settingsService
        currentSettings = settingsService.getSettings()
        
        loadData()
    }
    
    //MARK: Inputs
    func setSelected(index: Int) {
        items.forEach({
            $0.inputs.setSelected(select: false)
        })
        
        let newTaskTime = items[index]
        
        newTaskTime.inputs.setSelected(select: true)
        
        currentSettings.task.newTaskTime = newTaskTime.outputs.getTime()
        settingsService.saveSettings(settings: currentSettings)
    }
    
    //MARK: Outputs
    
    var items: [SettingsTasksNewTimeItemViewModelType] = []
    
}

extension SettingsTasksNewTimeViewModel {
    private func loadData() {
        items.removeAll()

        currentSettings.task.newTaskTime.getAllItems().forEach({
            items.append(SettingsTasksNewTimeItemViewModel(item: SettingsTaskNewTime(iconData: $0.getImageData(), title: $0.getLocalize(), time: $0, select: currentSettings.task.newTaskTime == $0)))
        })
    }
}
