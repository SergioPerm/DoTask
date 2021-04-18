//
//  SettingsTasksShortcutViewModel.swift
//  DoTask
//
//  Created by Сергей Лепинин on 16.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol SettingsTasksShortcutViewModelInputs {
    func setSelected(index: Int)
    func reloadData()
}

protocol SettingsTasksShortcutViewModelOutputs {
    var items: [SettingsTasksShortcutItemViewModelType] { get }
}

protocol SettingsTasksShortcutViewModelType {
    var inputs: SettingsTasksShortcutViewModelInputs { get }
    var outputs: SettingsTasksShortcutViewModelOutputs { get }
}

class SettingsTasksShortcutViewModel: SettingsTasksShortcutViewModelType, SettingsTasksShortcutViewModelInputs, SettingsTasksShortcutViewModelOutputs {
        
    private let settingsService: SettingService
    private var currentSettings: SettingService.Settings
    private let shortcutDataSource: ShortcutListDataSource
    
    var inputs: SettingsTasksShortcutViewModelInputs { return self }
    var outputs: SettingsTasksShortcutViewModelOutputs { return self }
    
    init(settingsService: SettingService, shortcutDataSource: ShortcutListDataSource) {
        self.settingsService = settingsService
        self.shortcutDataSource = shortcutDataSource
        self.currentSettings = settingsService.getSettings()
        
        loadData()
    }
    
    //MARK: Inputs
    func setSelected(index: Int) {
        items.forEach({
            $0.inputs.setSelected(select: false)
        })
        
        let defaultShortcut = items[index]
        
        defaultShortcut.inputs.setSelected(select: true)
        
        currentSettings.task.defaultShortcut = defaultShortcut.outputs.shortcutUID
        settingsService.saveSettings(settings: currentSettings)
    }
    
    func reloadData() {
        loadData()
    }
    
    //MARK: Outputs
    
    var items: [SettingsTasksShortcutItemViewModelType] = []
}

extension SettingsTasksShortcutViewModel {
    private func loadData() {
        items.removeAll()
        
        items.append(SettingsTasksShortcutItemViewModel(item: SettingsTasksShortcut(shortcut: nil, select: currentSettings.task.defaultShortcut == nil ? true : false)))
        
        shortcutDataSource.shortcuts.forEach({
            items.append(SettingsTasksShortcutItemViewModel(item: SettingsTasksShortcut(shortcut: $0, select: currentSettings.task.defaultShortcut == $0.uid ? true : false)))
        })
    }
}
