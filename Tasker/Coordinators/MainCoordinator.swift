//
//  MainCoordinator.swift
//  Tasker
//
//  Created by kluv on 22/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

class MainCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var router: RouterType?
    
    init(presenter: RouterType) {
        self.router = presenter
    }
    
    func start() {
        let vc = SlideMenuAssembly.createInstance(router: router)

        vc.openTaskListHandler = { menu in
            self.openTaskList(menu: menu)
        }
        vc.openSettingsHandler = { menu in
            self.openSettings(menu: menu)
        }
        vc.openDetailShortcutHandler = { shortcutUID in
            self.editShortcut(shortcutUID: shortcutUID)
        }
        
        router?.push(vc: vc, completion: nil)
    }
            
    func editShortcut(shortcutUID: String?) {
        let vc = DetailShortcutAssembly.createInstance(shortcutUID: shortcutUID, presenter: router)
        
        router?.push(vc: vc, completion: { [weak self] in
            self?.parentCoordinator?.childDidFinish(self)
        })
        
    }
    
    func openTaskList(menu: SlideMenuViewType?) {
        let vc = TaskListAssembly.createInstance(presenter: router)
        vc.slideMenu = menu
        
        vc.editTaskAction = { uid in
            self.editTask(taskUID: uid)
        }

        router?.push(vc: vc, completion: { [weak self] in
            self?.parentCoordinator?.childDidFinish(self)
        })
        
        menu?.parentController = vc
    }
    
    func openSettings(menu: SlideMenuViewType?) {
        menu?.toggleMenu()
        let vc = SettingsAssembly.createInstance(presenter: router)
        router?.push(vc: vc, completion: { [weak self] in
            self?.parentCoordinator?.childDidFinish(self)
        })
    }
    
    func editTask(taskUID: String?) {
        let child = DetailTaskCoordinator(presenter: router, taskUID: taskUID)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }
}
