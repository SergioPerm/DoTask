//
//  SettingsTasksShortcutItemViewModel.swift
//  DoTask
//
//  Created by Сергей Лепинин on 16.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol SettingsTasksShortcutItemViewModelInputs {
    func setSelected(select: Bool)
}

protocol SettingsTasksShortcutItemViewModelOutputs {
    var hexColor: String? { get }
    var itemTitle: String { get }
    var select: Bool { get }
    var shortcutUID: String? { get }
    var selectChangeEvent: Event<Bool> { get }
}

protocol SettingsTasksShortcutItemViewModelType: AnyObject {
    var inputs: SettingsTasksShortcutItemViewModelInputs { get }
    var outputs: SettingsTasksShortcutItemViewModelOutputs { get }
}

class SettingsTasksShortcutItemViewModel: SettingsTasksShortcutItemViewModelType, SettingsTasksShortcutItemViewModelInputs, SettingsTasksShortcutItemViewModelOutputs {
   
    private let item: SettingsTasksShortcut
    
    var inputs: SettingsTasksShortcutItemViewModelInputs { return self }
    var outputs: SettingsTasksShortcutItemViewModelOutputs { return self }
    
    init(item: SettingsTasksShortcut) {
        self.item = item
        self.selectChangeEvent = Event<Bool>()
    }
    
    // MARK: Inputs
    
    func setSelected(select: Bool) {
        selectChangeEvent.raise(select)
    }
    
    // MARK: Outputs
    
    var hexColor: String? {
        return item.shortcut?.color
    }
    
    var itemTitle: String {
        guard let shortcutTitle = item.shortcut?.name else { return R.string.localizable.last_SHORTCUT() }
        return shortcutTitle
    }
    
    var select: Bool {
        return item.select
    }
    
    var shortcutUID: String? {
        return item.shortcut?.uid
    }
    
    var selectChangeEvent: Event<Bool>
    
}
