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

        vc.openTaskListHandler = { menu, shortcutFilter in
            self.openTaskList(menu: menu, shortcutFilter: shortcutFilter)
        }
        vc.openSettingsHandler = { menu in
            self.openSettings(menu: menu)
        }
        vc.openDetailShortcutHandler = { shortcutUID in
            self.editShortcut(shortcutUID: shortcutUID)
        }
        
        router?.push(vc: vc, completion: nil, transition: nil)
    }
            
    func editShortcut(shortcutUID: String?) {
        let vc = DetailShortcutAssembly.createInstance(shortcutUID: shortcutUID, router: router)
                
        router?.push(vc: vc, completion: { [weak self] in
            self?.parentCoordinator?.childDidFinish(self)
        }, transition: CardModalTransitionController(viewController: vc, router: router))
    }
    
    func openTaskList(menu: SlideMenuViewType?, shortcutFilter: String? = nil) {
        
        if let menu = menu {
            if menu.enabled {
                menu.toggleMenu()
            }
        }
        
        let vc = TaskListAssembly.createInstance(router: router, shortcutFilter: shortcutFilter)
        vc.slideMenu = menu
        
        vc.editTaskAction = { uid, shortcutUID in
            self.editTask(taskUID: uid, shortcutUID: shortcutUID)
        }

        router?.push(vc: vc, completion: { [weak self] in
            self?.parentCoordinator?.childDidFinish(self)
        }, transition: nil)
        
        menu?.parentController = vc
    }
    
    func openSettings(menu: SlideMenuViewType?) {
        menu?.toggleMenu()
        let vc = SettingsAssembly.createInstance(presenter: router)
        router?.push(vc: vc, completion: { [weak self] in
            self?.parentCoordinator?.childDidFinish(self)
        }, transition: nil)
    }
    
    func editTask(taskUID: String?, shortcutUID: String?) {
        let child = DetailTaskCoordinator(presenter: router, taskUID: taskUID, shortcutUID: shortcutUID)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }
}
