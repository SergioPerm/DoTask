//
//  Event.swift
//  Tasker
//
//  Created by KLuV on 22.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

final class Event<Args> {
    
    private var handlers: [Weak<AnyObject>: (Args) -> Void] = [:]

    func subscribe<Subscriber: AnyObject>(
        _ subscriber: Subscriber,
        handler: @escaping (Subscriber, Args) -> Void) {

        let key = Weak<AnyObject>(subscriber)

        handlers = handlers.filter { $0.key.isAlive }

        handlers[key] = {
            [weak subscriber] args in
            guard let subscriber = subscriber else { return }
            handler(subscriber, args)
        }
    }

    func unsubscribe(_ subscriber: AnyObject) {
        let key = Weak<AnyObject>(subscriber)
        handlers[key] = nil
    }

    func raise(_ args: Args) {
        let aliveHandlers = handlers.filter { $0.key.isAlive }
        aliveHandlers.forEach { $0.value(args) }
    }
}

extension Event where Args == Void {
    func subscribe<Subscriber: AnyObject>(
        _ subscriber: Subscriber,
        handler: @escaping (Subscriber) -> Void) {

        subscribe(subscriber) { this, _ in
            handler(this)
        }
    }

    func raise() {
        raise(())
    }
}
