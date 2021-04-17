//
//  LocalizeService.swift
//  DoTask
//
//  Created by Сергей Лепинин on 03.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit
import Rswift

struct LocalizableStringResource {
    let key: String
    let tableName: String
    let bundle: Bundle
    let locales: [String]
    var staticString: String?
    
    let comment: String?

    init(stringResource: Rswift.StringResource) {
        self.key = stringResource.key
        self.tableName = stringResource.tableName
        self.bundle = stringResource.bundle
        self.locales = stringResource.locales
        self.comment = stringResource.comment
    }
    
    init(withStaticString: String) {
        self.key = ""
        self.tableName = ""
        self.bundle = Bundle()
        self.locales = []
        self.comment = ""
        self.staticString = withStaticString
    }
}

protocol LocalizableEntity {
    func subscribe()
}

protocol LocalizeServiceType: class {
    func subscribe(subscriber: UIView, whenChangeLocale: @escaping (_ locale: String) -> Void)
    func unsubscribe(subscriber: UIView)
    func localizeString(forKey: String, locale: String) -> String
    
    var currentLocal: SettingService.CurrentLanguage? { get }
}

protocol LocalizeServiceSettingsType {
    func changeLocale(localeCode: String)
}

class LocalizeService: LocalizeServiceType {
    private var subscribers: [UIView: (_ locale: String) -> Void] = [:]
    var currentLocal: SettingService.CurrentLanguage?
        
    init() {
        let settings: SettingService = AppDI.resolve()
        self.currentLocal = settings.getSettings().language
    }
    
    func subscribe(subscriber: UIView, whenChangeLocale: @escaping (_ locale: String) -> Void) {
        subscribers[subscriber] = whenChangeLocale
    }
    
    func unsubscribe(subscriber: UIView) {
        subscribers[subscriber] = nil
    }
    
    func localizeString(forKey: String, locale: String) -> String {
        if !locale.isEmpty {
            if let newLocal = SettingService.CurrentLanguage(rawValue: locale) {
                currentLocal = newLocal
            }
        }
        
        guard let currentLocal = currentLocal else { return ""}
        
        let bundlePath = Bundle.main.path(forResource: currentLocal.rawValue, ofType: "lproj")
        guard let path = bundlePath else { return "" }
        guard let localBundle = Bundle(path: path) else { return "" }
        
        return localBundle.localizedString(forKey: forKey, value: "", table: nil)
    }

}

extension LocalizeService: LocalizeServiceSettingsType {
    func changeLocale(localeCode: String) {
        subscribers.forEach({
            $0.value(localeCode)
        })
    }
}
