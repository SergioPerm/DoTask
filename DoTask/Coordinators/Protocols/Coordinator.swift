//
//  Coordinator.swift
//  DoTask
//
//  Created by kluv on 22/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

protocol Coordinator: NSObject {
    var parentCoordinator: Coordinator? { get set }
    var childCoordinators: [Coordinator] { get set }
    var router: RouterType? { get set }
    
    func start()
}

extension Coordinator {
    func childDidFinish(_ child: Coordinator?) {
        guard let child = child else { return }
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                child.parentCoordinator = nil
                break
            }
        }
    }
}
