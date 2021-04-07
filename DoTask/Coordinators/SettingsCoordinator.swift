//
//  SettingsCoordinator.swift
//  DoTask
//
//  Created by Сергей Лепинин on 30.03.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class SettingsCoordinator: NSObject, Coordinator {

    var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()

    var router: RouterType?

    init(router: RouterType?) {
        self.router = router
    }

    func start() {
        let vc: SettingsViewType = AppDI.resolve()
        
        vc.settingLanguageHandler = {
            
        }
        
        router?.push(vc: vc, completion: { [weak self] in
            self?.parentCoordinator?.childDidFinish(self)
        }, transition: nil)
    }
    
    func openLanguageSetting() {
        
    }
}
