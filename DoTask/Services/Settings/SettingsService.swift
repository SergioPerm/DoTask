//
//  SettingsService.swift
//  DoTask
//
//  Created by Сергей Лепинин on 04.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

class SettingService {
          
    enum CurrentLanguage: String, Codable, CaseIterable {
        case en
        case ru
        
        func getLocalize() -> LocalizableStringResource {
            switch self {
            case .en:
                return LocalizableStringResource(stringResource: R.string.localizable.en_Language)
            case .ru:
                return LocalizableStringResource(stringResource: R.string.localizable.ru_Language)
            }
        }
        
        func getImageData() -> Data {
            switch self {
            case .en:
                return R.image.settings.en()!.pngData()!
            case .ru:
                return R.image.settings.ru()!.pngData()!
            }
        }
        
        func getAllLanguages() -> [CurrentLanguage] {
            return CurrentLanguage.allCases
        }
    }

    enum NewTaskTime: String, Codable, CaseIterable {
        case startDay
        case endDay
        
        func getLocalize() -> LocalizableStringResource {
            switch self {
            case .startDay:
                return LocalizableStringResource(stringResource: R.string.localizable.first_IN_DAY)
            case .endDay:
                return LocalizableStringResource(stringResource: R.string.localizable.last_IN_DAY)
            }
        }
        
        func getImageData() -> Data {
            switch self {
            case .startDay:
                return R.image.settings.firstInDay()!.pngData()!
            case .endDay:
                return R.image.settings.lastInDay()!.pngData()!
            }
        }
        
        func getAllItems() -> [NewTaskTime] {
            return NewTaskTime.allCases
        }
    }

    struct TaskSetting: Codable {
        var newTaskTime: NewTaskTime
        var defaultShortcut: String?
        var showDoneTasksInToday: Bool
        var transferOverdueTasksToToday: Bool
    }
    
    struct Settings: Codable, PropertyIterator {
    
        var language: CurrentLanguage
        var task: TaskSetting
        var spotlight: Bool
                
        init() {
            //DEFAULT SETTINGS
            if let regionCode = Locale.current.regionCode {
                self.language = CurrentLanguage(rawValue: regionCode.lowercased())!
            } else {
                self.language = .en
            }

            self.task = TaskSetting(newTaskTime: .endDay, defaultShortcut: "", showDoneTasksInToday: false, transferOverdueTasksToToday: false)
            self.spotlight = true
        }
    
    }
    
    private var currentSettings: Settings
    private let defaults = UserDefaults.standard
    
    init() {
        self.currentSettings = Settings()
               
        saveCurrentSettings()
        
        if defaults.object(forKey: "appSettings") == nil {
            //Write default settings
            saveCurrentSettings()
        } else {
            loadCurrentSettings()
        }
    }
    
    private func loadCurrentSettings() {
        let defaults = UserDefaults.standard
        
        if let saveSettings = defaults.object(forKey: "appSettings") as? Data {
            let decoder = JSONDecoder()
            if let loadedSettings = try? decoder.decode(Settings.self, from: saveSettings) {
                self.currentSettings = loadedSettings
            }
        }
    }
    
    private func saveCurrentSettings() {
        let encoder = JSONEncoder()
        
        if let encoded = try? encoder.encode(self.currentSettings) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "appSettings")
        }
    }
    
    func getSettings() -> Settings {
        return currentSettings
    }
    
    func saveSettings(settings: Settings) {
        currentSettings = settings
        saveCurrentSettings()
    }
    
}

