//
//  SettingsItemViewModel.swift
//  DoTask
//
//  Created by Сергей Лепинин on 05.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol SettingsItemViewModelInputs {
    func selectItem()
}

protocol SettingsItemViewModelOutputs {
    var singleValueSetting: Bool { get }
    var iconData: Data { get }
    var itemValue: LocalizableStringResource? { get }
    var itemTitle: LocalizableStringResource { get }
}

protocol SettingsItemViewModelType: AnyObject {
    var inputs: SettingsItemViewModelInputs { get }
    var outputs: SettingsItemViewModelOutputs { get }
}

class SettingsItemViewModel: SettingsItemViewModelType, SettingsItemViewModelInputs, SettingsItemViewModelOutputs {

    private let selectHandler: () -> Void
    private let settingsItem: SettingsMainItem
    
    var inputs: SettingsItemViewModelInputs { return self }
    var outputs: SettingsItemViewModelOutputs { return self }
    
    init(settingsItem: SettingsMainItem, selectAction: @escaping () -> Void) {
        self.selectHandler = selectAction
        self.settingsItem = settingsItem
    }
    
    // MARK: Inputs
    
    func selectItem() {
        selectHandler()
    }
    
    // MARK: Outputs
    
    var singleValueSetting: Bool {
        return settingsItem.singleValueItem
    }
    
    var iconData: Data {
        return settingsItem.iconData
    }

    var itemValue: LocalizableStringResource? {
        return settingsItem.valueTitle
    }
    var itemTitle: LocalizableStringResource {
        return settingsItem.title
    }
    
}
