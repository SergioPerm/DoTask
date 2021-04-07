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
        
//        func getImageData() -> Data {
//            switch self {
//            case .en:
//                
//            case .ru:
//                
//            }
//        }
        
        func getAllLanguages() -> [CurrentLanguage] {
            return CurrentLanguage.allCases
        }
    }

    enum NewTaskTime: String, Codable {
        case startDay
        case endDay
    }

    struct TaskSetting: Codable {
        let newTaskTime: NewTaskTime
        let defaultShortcut: String
        let showDoneTasks: Bool
    }
    
    struct Settings: Codable {
    
        var language: CurrentLanguage
        var task: TaskSetting
        var spotlight: Bool
                
        init() {
            //DEFAULT SETTINGS
            if let currentLanguage = CurrentLanguage(rawValue: Locale.current.languageCode!) {
                self.language = currentLanguage
            } else {
                self.language = .en
            }

            self.task = TaskSetting(newTaskTime: .endDay, defaultShortcut: "", showDoneTasks: false)
            self.spotlight = true
        }
    
    }
    
    private var currentSettings: Settings
    private let defaults = UserDefaults.standard
    
    init() {
        self.currentSettings = Settings()
        
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
                print(loadedSettings)
                print("test ok")
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

