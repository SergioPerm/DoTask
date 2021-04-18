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
        
        vc.settingLanguageHandler = { [weak self] in
            self?.openLanguageSetting()
        }
        
        vc.settingTasksHandler = { [weak self] in
            self?.openTasksSetting()
        }
        
        vc.settingSpotlightHandler = { [weak self] in
            self?.openSpotlightSettings()
        }
        
        router?.push(vc: vc, completion: { [weak self] in
            self?.parentCoordinator?.childDidFinish(self)
        }, transition: nil)
    }
    
    func openLanguageSetting() {
        let vc: SettingsLanguageViewType = AppDI.resolve()
        router?.push(vc: vc, completion: nil, transition: nil)
    }
    
    func openTasksSetting() {
        let vc: SettingsTasksViewType = AppDI.resolve()
        
        vc.settingNewTaskTimeHandler = { [weak self] in
            self?.openNewTaskTimeSetting()
        }
        
        vc.settingDefaultShortcutHandler = { [weak self] in
            self?.openDefaultShortcutSetting()
        }
        
        vc.settingShowCompletedTasksHandler = { [weak self] in
            self?.openShowDoneTasksSetting()
        }
        
        vc.settingTransferOverdueHandler = { [weak self] in
            self?.openTrasnferOverdueSetting()
        }
        
        router?.push(vc: vc, completion: nil, transition: nil)
    }
    
    func openNewTaskTimeSetting() {
        let vc: SettingsTasksNewTimeViewType = AppDI.resolve()
        router?.push(vc: vc, completion: nil, transition: nil)
    }
    
    func openDefaultShortcutSetting() {
        let vc: SettingsTasksShortcutViewType = AppDI.resolve()
        router?.push(vc: vc, completion: nil, transition: nil)
    }
    
    func openShowDoneTasksSetting() {
        let vc: SettingsTasksShowDoneViewType = AppDI.resolve()
        router?.push(vc: vc, completion: nil, transition: nil)
    }
    
    func openTrasnferOverdueSetting() {
        let vc: SettingsTasksTransferOverdueViewType = AppDI.resolve()
        router?.push(vc: vc, completion: nil, transition: nil)
    }
    
    func openSpotlightSettings() {
        let vc: SettingsTasksSpotlightViewType = AppDI.resolve()
        router?.push(vc: vc, completion: nil, transition: nil)
    }
}
