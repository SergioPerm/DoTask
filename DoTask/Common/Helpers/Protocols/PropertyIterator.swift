//
//  PropertyIterator.swift
//  DoTask
//
//  Created by Сергей Лепинин on 10.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol PropertyIterator {
    func allProperties() throws -> [String: Any]
}

extension PropertyIterator {
    func allProperties() throws -> [String: Any] {

        var result: [String: Any] = [:]

        let mirror = Mirror(reflecting: self)
       
        guard let style = mirror.displayStyle else {
            throw NSError(domain: "com.itotdel", code: 666, userInfo: nil)
        }
        
        if style != .class && style != .struct {
            throw NSError(domain: "com.itotdel", code: 666, userInfo: nil)
        }
        
        for (propertyLabel, propertyValue) in mirror.children {
            guard let label = propertyLabel else {
                continue
            }

            result[label] = propertyValue
        }

        return result
    }
}
