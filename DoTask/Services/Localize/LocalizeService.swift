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
    
    let comment: String?
    
    public init(stringResource: Rswift.StringResource) {
        self.key = stringResource.key
        self.tableName = stringResource.tableName
        self.bundle = stringResource.bundle
        self.locales = stringResource.locales
        self.comment = stringResource.comment
    }
}

protocol LocalizableEntity {
    func subscribe()
}

protocol LocalizeServiceType: class {
    func subscribe(subscriber: UIView, whenChangeLocale: @escaping (_ locale: String) -> Void)
    func unsubscribe(subscriber: UIView)
    func localizeString(forKey: String) -> String
}

protocol LocalizeServiceSettingsType {
    func changeLocale()
}

class LocalizeService: LocalizeServiceType {
    private var subscribers: [UIView: (_ locale: String) -> Void] = [:]
    
    func subscribe(subscriber: UIView, whenChangeLocale: @escaping (_ locale: String) -> Void) {
        subscribers[subscriber] = whenChangeLocale
    }
    
    func unsubscribe(subscriber: UIView) {
        subscribers[subscriber] = nil
    }
    
    func localizeString(forKey: String) -> String {
        //default Locale.current.languageCode
        let bundlePath = Bundle.main.path(forResource: "ru", ofType: "lproj")
        guard let path = bundlePath else { return "" }
        guard let localBundle = Bundle(path: path) else { return "" }
        
        return localBundle.localizedString(forKey: forKey, value: "", table: nil)
    }
}

extension LocalizeService: LocalizeServiceSettingsType {
    func changeLocale() {
        
    }
}
