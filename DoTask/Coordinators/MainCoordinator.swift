//
//  MainCoordinator.swift
//  DoTask
//
//  Created by kluv on 22/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit
import DITranquillity

class MainCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var router: RouterType?
    
    init(presenter: RouterType) {
        self.router = presenter
    }
    
    func start() {
        let vc: SlideMenuViewType = AppDI.resolve()//SlideMenuAssembly.createInstance(router: router)

        vc.openTaskListHandler = { menu, shortcutFilter in
            self.openTaskList(menu: menu, shortcutFilter: shortcutFilter)
        }
        vc.openSettingsHandler = { menu in
            self.openSettings(menu: menu)
        }
        vc.openDetailShortcutHandler = { shortcutUID in
            self.editShortcut(shortcutUID: shortcutUID)
        }
        vc.openTaskDiaryHandler = { menu in
            self.openTaskDiary(menu: menu)
        }
        
        router?.push(vc: vc, completion: nil, transition: nil)
    }
            
    func editShortcut(shortcutUID: String?) {
        let vc: DetailShortcutViewType = AppDI.resolve()//DetailShortcutAssembly.createInstance(shortcutUID: shortcutUID, router: router)
        vc.shortcutUID = shortcutUID
        
        router?.push(vc: vc, completion: { [weak self] in
            self?.parentCoordinator?.childDidFinish(self)
        }, transition: CardModalTransitionController(viewController: vc, router: router))
    }
    
    func openTaskDiary(menu: SlideMenuViewType?) {
        let vc: TaskDiaryViewPresentable = AppDI.resolve()//TaskDiaryAssembly.createInstance(router: router)

        vc.editTaskAction = { uid, shortcutUID in
            self.editTask(taskUID: uid, shortcutUID: shortcutUID, taskDate: nil)
        }

        let transition = FlipTransitionController()

        router?.push(vc: vc, completion: { [weak self] in
            self?.parentCoordinator?.childDidFinish(self)
        }, transition: transition)
    }
    
    func openTaskList(menu: SlideMenuViewType?, shortcutFilter: String? = nil) {
        if let menu = menu {
            if menu.enabled {
                menu.toggleMenu()
            }
        }
        
        let vc: TaskListViewType = AppDI.resolve()
        vc.slideMenu = menu
    
        vc.filter = TaskListFilter(shortcutFilter: shortcutFilter, dayFilter: nil)

        vc.editTaskAction = { uid, shortcutUID, taskDate in
            self.editTask(taskUID: uid, shortcutUID: shortcutUID, taskDate: taskDate)
        }
        vc.speechTaskAction = { recognizer, shortcutUID, taskDate in
            self.speechTask(recognizer: recognizer, shortcutUID: shortcutUID, taskDate: taskDate)
        }

        router?.push(vc: vc, completion: { [weak self] in
            self?.parentCoordinator?.childDidFinish(self)
        }, transition: nil)
        
        if let menuParent = vc as? MenuParentControllerType {
            menu?.parentController = menuParent
        }
    }
    
    func openSettings(menu: SlideMenuViewType?) {
        menu?.toggleMenu()
        let vc: SettingsViewController = AppDI.resolve()
        router?.push(vc: vc, completion: { [weak self] in
            self?.parentCoordinator?.childDidFinish(self)
        }, transition: nil)
    }
    
    func editTask(taskUID: String?, shortcutUID: String?, taskDate: Date?) {
        let child = DetailTaskCoordinator(router: router, taskUID: taskUID, shortcutUID: shortcutUID, taskDate: taskDate)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }
    
    func speechTask(recognizer: UILongPressGestureRecognizer, shortcutUID: String?, taskDate: Date?) {
//        let vc = SpeechTaskAssembly.createInstance(router: router, recognizer: recognizer, shortcutFilter: shortcutUID)
//
//        let transition = SpeechRecorderTransitionController()
//
//        router?.push(vc: vc, completion: {[weak self] in
//            self?.parentCoordinator?.childDidFinish(self)
//        }, transition: transition)
    }
    
}
