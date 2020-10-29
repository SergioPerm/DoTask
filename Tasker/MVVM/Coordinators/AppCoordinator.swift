//
//  AppCoordinator.swift
//  Tasker
//
//  Created by kluv on 27/10/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

class AppCordinator: NSObject, Coordinator {
    var childCoordinators: [Coordinator] = []
    weak var parent: Coordinator? = nil
        
    let navigationController: UINavigationController
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
    }
    
    func start() {
        
    }
    
    
}
