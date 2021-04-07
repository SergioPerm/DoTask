//
//  SettingsLanguageItemViewModel.swift
//  DoTask
//
//  Created by Сергей Лепинин on 06.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol SettingsLanguageItemViewModelOutputs {
    var iconData: Data { get }
    var itemTitle: LocalizableStringResource { get }
    var select: Bool { get }
}

protocol SettingsLanguageItemViewModelType {
    var outputs: SettingsLanguageItemViewModelOutputs { get }
}

class SettingsLanguageItemViewModel: SettingsLanguageItemViewModelType, SettingsLanguageItemViewModelOutputs {
    
    private let item: SettingsLanguageItem
    
    var outputs: SettingsLanguageItemViewModelOutputs { return self }
    
    init(item: SettingsLanguageItem) {
        self.item = item
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
    
}

