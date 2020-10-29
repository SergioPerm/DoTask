//
//  Coordinator.swift
//  Tasker
//
//  Created by kluv on 27/10/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

protocol Coordinator: class {
    var childCoordinators: [Coordinator] { get set }
    var parent: Coordinator? { get set }
    
    func add(childCoordinator coordinator: Coordinator)
    func remove(childCoordinator coordinator: Coordinator)
    
    func start()
}

extension Coordinator {
    func add(childCoordinator coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func remove(childCoordinator coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}
