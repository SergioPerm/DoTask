//
//  Weak.swift
//  DoTask
//
//  Created by KLuV on 22.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

/// MVVM binding
/// Обертка для хранения подписчиков в классе Event, которая держит слабую ссылку на экземпляр ссылочного типа, передаваемый в инициализатор.
/// Если в инициализатор пришло что-то отличное от nil, обертка запоминает ObjectIdentifier этого объекта,
/// который впоследствии используется для реализации Hashable

final class Weak<T: AnyObject> {
    
    private let id: ObjectIdentifier?
    private(set) weak var value: T?

    /// Это живое?
    var isAlive: Bool {
        return value != nil
    }
    
    /// Создаем weak объект
    /// - Parameter value: Объект который нужно обернуть в Weak
    init(_ value: T?) {
        self.value = value
        if let value = value {
            id = ObjectIdentifier(value)
        } else {
            id = nil
        }
    }
    
    /// Отдаем объект
    /// - Returns: Объект из Weak
    func getValue() -> T? {
        return value
    }
}

// MARK: Hashable
extension Weak: Hashable {
    static func == (lhs: Weak<T>, rhs: Weak<T>) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        if let id = id {
            hasher.combine(id)
        }
    }
}
