//
//  SplashDependency.swift
//  DoTask
//
//  Created by Сергей Лепинин on 28.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation
import DITranquillity

class SplashDependency: DIPart {
    static func load(container: DIContainer) {
        
        container.register({
            SplashViewController(router: $0, presentableControllerViewType: .containerChild)
        })
        
    }
}
