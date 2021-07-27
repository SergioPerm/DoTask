//
//  UserDefaultsService.swift
//  DoTask
//
//  Created by Sergio Lechini on 25.07.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

enum OnLaunchDataType: String {
    case openTask = "DOTASK_OPENTASK"
}

protocol OnLaunchAppData {
    func save(dataType: OnLaunchDataType, data: String)
    func read(dataType: OnLaunchDataType) -> String?
    func remove(dataType: OnLaunchDataType)
}

final class UserDefaultService {
    let defaults: UserDefaults = UserDefaults.standard
}

extension UserDefaultService: OnLaunchAppData {
    func save(dataType: OnLaunchDataType, data: String) {
        defaults.set(data, forKey: dataType.rawValue)
    }
    
    func read(dataType: OnLaunchDataType) -> String? {
        if let stringData = defaults.object(forKey: dataType.rawValue) as? String {
            return stringData
        }
        
        return nil
    }
    
    func remove(dataType: OnLaunchDataType) {
        defaults.removeObject(forKey: dataType.rawValue)
    }
}
