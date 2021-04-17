//
//  SettingsTasksViewModel.swift
//  DoTask
//
//  Created by Сергей Лепинин on 15.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol SettingsTasksViewModelInputs {
    func setNewTaskTimeHandler(handler: (() -> Void)?)
    func setDefaultShortcutHandler(handler: (() -> Void)?)
    func setShowCompletedTasksHandler(handler: (() -> Void)?)
    func setTransferOverdueHandler(handler: (() -> Void)?)
}

protocol SettingsTasksViewModelOutputs {
    var items: [SettingsItemViewModelType] { get }
}

protocol SettingsTasksViewModelType {
    var inputs: SettingsTasksViewModelInputs { get }
    var outputs: SettingsTasksViewModelOutputs { get }
}

class SettingsTasksViewModel: SettingsTasksViewModelType, SettingsTasksViewModelInputs, SettingsTasksViewModelOutputs {
        
    private let settingsService: SettingService
    private let shortcutDatasource: ShortcutListDataSource
    
    private var newTaskTimeHandler: (() -> Void)?
    private var defaultShortcutHandler: (() -> Void)?
    private var showCompletedTasksHandler: (() -> Void)?
    private var transferOverdueHandler: (() -> Void)?
    
    var inputs: SettingsTasksViewModelInputs { return self }
    var outputs: SettingsTasksViewModelOutputs { return self }
    
    init(settingsService: SettingService, shortcutDataSource: ShortcutListDataSource) {
        self.settingsService = settingsService
        self.shortcutDatasource = shortcutDataSource
        loadData()
    }
    
    //MARK: Inputs
    
    func setNewTaskTimeHandler(handler: (() -> Void)?) {
        newTaskTimeHandler = handler
    }
    
    func setDefaultShortcutHandler(handler: (() -> Void)?) {
        defaultShortcutHandler = handler
    }
    
    func setShowCompletedTasksHandler(handler: (() -> Void)?) {
        showCompletedTasksHandler = handler
    }
    
    func setTransferOverdueHandler(handler: (() -> Void)?) {
        transferOverdueHandler = handler
    }
    
    //MARK: Outputs
    
    var items: [SettingsItemViewModelType] = []
    
}

extension SettingsTasksViewModel {
    private func loadData() {
        items.removeAll()
        
        let settings = settingsService.getSettings()
                
        let newTaskTime = SettingsMainItem(iconData: R.image.settings.newTaskTime()!.pngData()!, title: LocalizableStringResource(stringResource: R.string.localizable.settings_TASK_NEW_TIME), singleValueItem: true, valueTitle: settings.task.newTaskTime.getLocalize())
        
        var defaultShortcutTitle = ""
        if let shortcutUID = settings.task.defaultShortcut {
            if let shortcut = shortcutDatasource.shortcutByIdentifier(identifier: shortcutUID) {
                defaultShortcutTitle = shortcut.name
            }
        }
        
        let defaultShortcut = SettingsMainItem(iconData: R.image.settings.defaultShortcut()!.pngData()!, title: LocalizableStringResource(stringResource: R.string.localizable.settings_TASK_SHORTCUT), singleValueItem: true, valueTitle: LocalizableStringResource(withStaticString: defaultShortcutTitle))
        
        let showDoneTasksInTodayLocalizeValue = settings.task.showDoneTasksInToday ? LocalizableStringResource(stringResource: R.string.localizable.yeS) : LocalizableStringResource(stringResource: R.string.localizable.nO)
        
        let showDoneTasksInToday = SettingsMainItem(iconData: R.image.settings.showDoneTasks()!.pngData()!, title: LocalizableStringResource(stringResource: R.string.localizable.settings_TASK_SHOW_DONE), singleValueItem: true, valueTitle: showDoneTasksInTodayLocalizeValue)
                
        let transferOverdueLocalizeValue = settings.task.transferOverdueTasksToToday ? LocalizableStringResource(stringResource: R.string.localizable.yeS) : LocalizableStringResource(stringResource: R.string.localizable.nO)
        
        let transferOverdueTasks = SettingsMainItem(iconData: R.image.settings.transferOverdueTasks()!.pngData()!, title: LocalizableStringResource(stringResource: R.string.localizable.settings_TASK_TRANSFER_OVERDUE), singleValueItem: true, valueTitle: transferOverdueLocalizeValue)
        
        items.append(SettingsItemViewModel(settingsItem: newTaskTime, selectAction: { [weak self] in
            if let action = self?.newTaskTimeHandler {
                action()
            }
        }))

        items.append(SettingsItemViewModel(settingsItem: defaultShortcut, selectAction: { [weak self] in
            if let action = self?.defaultShortcutHandler {
                action()
            }
        }))
        
        items.append(SettingsItemViewModel(settingsItem: showDoneTasksInToday, selectAction: {
            
        }))
        
        items.append(SettingsItemViewModel(settingsItem: transferOverdueTasks, selectAction: {
            
        }))

    }
}
