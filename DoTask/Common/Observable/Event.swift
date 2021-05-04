//
//  Event.swift
//  DoTask
//
//  Created by KLuV on 22.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

/// MVVM binding
/// Класс позволяет подписываться на событие с помощью метода subscribe(_:handler:)
/// и отписываться от него с помощью метода unsubscribe(_:).
/// С помощью метода raise(_:) можно уведомить всех подписчиков об измении данных
final class Event<Args> {
    
    // Подписчики и обработчики
    private var handlers: [Weak<AnyObject>: (Args) -> Void] = [:]
    
    /// Подписаться на событие
    /// - Parameters:
    ///   - subscriber: Подписчик
    ///   - handler: Обработчик
    func subscribe<Subscriber: AnyObject>(_ subscriber: Subscriber, handler: @escaping (Subscriber, Args) -> Void) {
        let key = Weak<AnyObject>(subscriber)

        handlers = handlers.filter { $0.key.isAlive }

        handlers[key] = {
            [weak subscriber] args in
            guard let subscriber = subscriber else { return }
            handler(subscriber, args)
        }
    }
    
    /// Отписаться от события
    /// - Parameter subscriber: Подписчик
    func unsubscribe(_ subscriber: AnyObject) {
        let key = Weak<AnyObject>(subscriber)
        handlers[key] = nil
    }
    
    /// Уведомить всех подписчиков о событии с передачей аргумента
    /// - Parameter args: Значение аргумента
    func raise(_ args: Args) {
        let aliveHandlers = handlers.filter { $0.key.isAlive }
        aliveHandlers.forEach { $0.value(args) }
    }
}

/// Extension для подписки без использования аргумента
extension Event where Args == Void {
    
    /// Подписаться на событие
    /// - Parameters:
    ///   - subscriber: Подписчик
    ///   - handler: Обработчик
    func subscribe<Subscriber: AnyObject>(_ subscriber: Subscriber, handler: @escaping (Subscriber) -> Void) {
        subscribe(subscriber) { this, _ in
            handler(this)
        }
    }
    
    /// Уведомить всех подписчиков о событии
    func raise() {
        raise(())
    }
}
