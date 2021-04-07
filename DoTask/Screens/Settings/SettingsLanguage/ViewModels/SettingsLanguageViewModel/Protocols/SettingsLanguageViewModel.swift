//
//  SettingsLanguageViewModelType.swift
//  DoTask
//
//  Created by Сергей Лепинин on 06.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol SettingsLanguageViewModelOutputs {
    var items: [SettingsLanguageItemViewModelType] { get }
}

protocol SettingsLanguageViewModelType {
    var outputs: SettingsLanguageViewModelOutputs { get }
}

class SettingsLanguageViewModel: SettingsLanguageViewModelType, SettingsLanguageViewModelOutputs {
    
    private let settingsService: SettingService
        
    var outputs: SettingsLanguageViewModelOutputs { return self }
    
    init(settingsService: SettingService) {
        self.settingsService = settingsService
    }
    
    // MARK: Outputs
    
    var items: [SettingsLanguageItemViewModelType] = []
    
}

extension SettingsLanguageViewModel {
    private func loadData() {
        
        let settings = settingsService.getSettings()
        let langArr = settings.language.getAllLanguages()
        
//        for lang in langArr {
//
//            let langItem = SettingsLanguageItem(iconData: <#T##Data#>, title: <#T##LocalizableStringResource#>, select: <#T##Bool#>)
//
//        }
        
    }
}

