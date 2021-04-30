//
//  SettingsLanguageItemViewModel.swift
//  DoTask
//
//  Created by Сергей Лепинин on 06.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol SettingsLanguageItemViewModelInputs {
    func setSelected(select: Bool)
}

protocol SettingsLanguageItemViewModelOutputs {
    var iconData: Data { get }
    var itemTitle: LocalizableStringResource { get }
    var select: Bool { get }
    var language: SettingService.CurrentLanguage { get }
    
    var selectChangeEvent: Event<Bool> { get }
}

protocol SettingsLanguageItemViewModelType: AnyObject {
    var inputs: SettingsLanguageItemViewModelInputs { get }
    var outputs: SettingsLanguageItemViewModelOutputs { get }
}

class SettingsLanguageItemViewModel: SettingsLanguageItemViewModelType, SettingsLanguageItemViewModelInputs, SettingsLanguageItemViewModelOutputs {
    
    private let item: SettingsLanguageItem
    
    var inputs: SettingsLanguageItemViewModelInputs { return self }
    var outputs: SettingsLanguageItemViewModelOutputs { return self }
    
    init(item: SettingsLanguageItem) {
        self.item = item
        
        self.selectChangeEvent = Event<Bool>()
    }
    
    // MARK: Inputs
    
    func setSelected(select: Bool) {
        selectChangeEvent.raise(select)
    }
    
    // MARK: Outputs
    
    var iconData: Data {
        return item.iconData
    }
    
    var itemTitle: LocalizableStringResource {
        return item.title
    }
    
    var select: Bool {
        return item.select
    }
    
    var selectChangeEvent: Event<Bool>
    
    var language: SettingService.CurrentLanguage {
        return item.language
    }
    
}

