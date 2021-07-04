//
//  PermissionDeniedDependency.swift
//  DoTask
//
//  Created by Sergio Lechini on 03.07.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation
import DITranquillity

class PermissionDeniedDependency: DIPart {
    static func load(container: DIContainer) {

        container.register({
            PermissionDeniedViewController(router: $0, presentableControllerViewType: .presentWithTransition)
        }).as(PermissionDeniedViewType.self)
        
    }
}
