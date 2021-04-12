//
//  SettingsLanguageViewModelType.swift
//  DoTask
//
//  Created by Сергей Лепинин on 06.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol SettingsLanguageViewModelInputs {
    func setSelected(index: Int)
}

protocol SettingsLanguageViewModelOutputs {
    var items: [SettingsLanguageItemViewModelType] { get }
}

protocol SettingsLanguageViewModelType {
    var inputs: SettingsLanguageViewModelInputs { get }
    var outputs: SettingsLanguageViewModelOutputs { get }
}

class SettingsLanguageViewModel: SettingsLanguageViewModelType, SettingsLanguageViewModelInputs, SettingsLanguageViewModelOutputs {
    
    private let localizeService: LocalizeServiceSettingsType
    private let settingsService: SettingService
    private var currentSettings: SettingService.Settings
        
    var inputs: SettingsLanguageViewModelInputs { return self }
    var outputs: SettingsLanguageViewModelOutputs { return self }
    
    init(settingsService: SettingService, localizeService: LocalizeServiceSettingsType) {
        self.settingsService = settingsService
        self.localizeService = localizeService
        currentSettings = settingsService.getSettings()
        
        loadData()
    }
    
    // MARK: inputs
    
    func setSelected(index: Int) {
        items.forEach({
            $0.inputs.setSelected(select: false)
        })
        
        items[index].inputs.setSelected(select: true)
        
        currentSettings.language = items[index].outputs.language
        settingsService.saveSettings(settings: currentSettings)
        
        localizeService.changeLocale(localeCode: items[index].outputs.language.rawValue)
        //
    }
    
    // MARK: Outputs
    
    var items: [SettingsLanguageItemViewModelType] = []
    
}

extension SettingsLanguageViewModel {
    private func loadData() {
        items.removeAll()
        
        let langArr = currentSettings.language.getAllLanguages()
        
        for lang in langArr {
            let langItem = SettingsLanguageItem(iconData: lang.getImageData(), title: lang.getLocalize(), select: currentSettings.language == lang, language: lang)
            items.append(SettingsLanguageItemViewModel(item: langItem))
        }
    }
}

