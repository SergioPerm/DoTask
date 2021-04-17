//
//  SettingsTasksNewTimeItemViewModel.swift
//  DoTask
//
//  Created by Сергей Лепинин on 15.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol SettingsTasksNewTimeItemViewModelInputs {
    func setSelected(select: Bool)
}

protocol SettingsTasksNewTimeItemViewModelOutputs {
    var iconData: Data { get }
    var itemTitle: LocalizableStringResource { get }
    var select: Bool { get }
    var selectChangeEvent: Event<Bool> { get }
    
    func getTime() -> SettingService.NewTaskTime
}

protocol SettingsTasksNewTimeItemViewModelType: class {
    var inputs: SettingsTasksNewTimeItemViewModelInputs { get }
    var outputs: SettingsTasksNewTimeItemViewModelOutputs { get }
}

class SettingsTasksNewTimeItemViewModel: SettingsTasksNewTimeItemViewModelType, SettingsTasksNewTimeItemViewModelInputs, SettingsTasksNewTimeItemViewModelOutputs {
    
    private let item: SettingsTaskNewTime
    
    var inputs: SettingsTasksNewTimeItemViewModelInputs { return self }
    var outputs: SettingsTasksNewTimeItemViewModelOutputs { return self }
    
    init(item: SettingsTaskNewTime) {
        self.item = item
        self.selectChangeEvent = Event<Bool>()
    }
    
    // MARK: Inputs
    
    func setSelected(select: Bool) {
        selectChangeEvent.raise(select)
    }
    
    // MARK: Outputs
    
    var itemTitle: LocalizableStringResource {
        return item.title
    }
    
    var select: Bool {
        return item.select
    }
    
    var selectChangeEvent: Event<Bool>
    
    func getTime() -> SettingService.NewTaskTime {
        return item.time
    }
    
    var iconData: Data {
        return item.iconData
    }
    
}
