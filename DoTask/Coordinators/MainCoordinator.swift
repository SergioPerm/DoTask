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
    
    func start(finishCompletion: (() -> Void)?) {
        
        let notifyService: PushNotificationService = AppDI.resolve()
        notifyService.registerCategories()
        
        let vc: SplashViewController = AppDI.resolve()
        
        router?.push(vc: vc, completion: { [weak self] in
            self?.openOnboarding()
        }, transition: FullScreenTransitionController())
    }
          
    func openOnboarding() {
        let settingsService: SettingService = AppDI.resolve()
        var currentSettings = settingsService.getSettings()
        
        if currentSettings.firstRun {
            let vc: OnboardingViewType = AppDI.resolve()
            
            vc.onDoNotAllowNotify = { [weak self] in
                self?.openNotifyPermissionInfo()
            }
            
            vc.onDoNotAllowSpeech = { [weak self] in
                self?.openSpeechPermissionInfo()
            }
            
            createStockShortcuts()
            
            router?.push(vc: vc, completion: {[weak self] in
                currentSettings.firstRun = false
                settingsService.saveSettings(settings: currentSettings)
                
                self?.openMainScreen()
            }, transition: nil)
        } else {
            openMainScreen()
        }
    }
    
    func openMainScreen() {
        let vc: SlideMenuViewType = AppDI.resolve()
        
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
        let vc: DetailShortcutViewType = AppDI.resolve()
        vc.shortcutUID = shortcutUID
        vc.openMainTaskListHandler = {
            self.openTaskList(menu: AppDI.resolve())
        }
        
        router?.push(vc: vc, completion: nil, transition: CardModalTransitionController(viewController: vc, router: router))
    }
    
    func openTaskDiary(menu: SlideMenuViewType?) {
        let vc: TaskDiaryViewPresentable = AppDI.resolve()//TaskDiaryAssembly.createInstance(router: router)

        vc.editTaskAction = { uid, shortcutUID in
            self.editTask(taskUID: uid, shortcutUID: shortcutUID, taskDate: nil)
        }

        let transition = FlipTransitionController()

        router?.push(vc: vc, completion: nil, transition: transition)
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

        router?.push(vc: vc, completion: nil, transition: nil)
        
        if let menuParent = vc as? MenuParentControllerType {
            menu?.parentController = menuParent
        }
    }
    
    func openSettings(menu: SlideMenuViewType?) {
        let child = SettingsCoordinator(router: router)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start(finishCompletion: {
            menu?.toggleMenu()
        })
    }
    
    func editTask(taskUID: String?, shortcutUID: String?, taskDate: Date?) {
        let child = DetailTaskCoordinator(router: router, taskUID: taskUID, shortcutUID: shortcutUID, taskDate: taskDate)
        
        child.onNotifyPermissionDenied = { [weak self] in
            self?.openNotifyPermissionInfo()
        }
        
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start(finishCompletion: nil)
    }
    
    func speechTask(recognizer: UILongPressGestureRecognizer, shortcutUID: String?, taskDate: Date?) {
        
        //Check did allow permission for speech
        let speechService: SpeechRecognitionServiceType = AppDI.resolve()
        
        speechService.checkAuthorization { [weak self] didAllow in
            guard let strongSelf = self else { return }
            
            if !didAllow {
                strongSelf.openSpeechPermissionInfo()
                return
            }
            
            let vc: SpeechTaskViewType = AppDI.resolve()
            
            vc.longTapRecognizer = recognizer
            vc.shortcutUID = shortcutUID
            vc.taskDate = taskDate
            
            vc.onDoNotAllowSpeech = {
                strongSelf.openSpeechPermissionInfo()
            }
            
            let transition = SpeechRecorderTransitionController()
            strongSelf.router?.push(vc: vc, completion: nil, transition: transition)
        }
    }
    
    func openNotifyPermissionInfo() {
        let vc: PermissionDeniedViewType = AppDI.resolve()
        
        vc.setLocalizeTitle(title: LocalizableStringResource(stringResource: R.string.localizable.permission_TITLE_NOTIFY))
        vc.setLocalizeInfo(info: LocalizableStringResource(stringResource: R.string.localizable.permission_INFO_NOTIFY))
        vc.setIcon(icon: R.image.permissionDenied.permissionNotify())
        
        let transition = ZoomModalTransitionController()
        
        router?.push(vc: vc, completion: nil, transition: transition)
    }
    
    func openSpeechPermissionInfo() {
        let vc: PermissionDeniedViewType = AppDI.resolve()
        
        vc.setLocalizeTitle(title: LocalizableStringResource(stringResource: R.string.localizable.permission_TITLE_SPEECH))
        vc.setLocalizeInfo(info: LocalizableStringResource(stringResource: R.string.localizable.permission_INFO_SPEECH))
        vc.setIcon(icon: R.image.permissionDenied.permissionSpeech())
        
        let transition = ZoomModalTransitionController()
        
        router?.push(vc: vc, completion: nil, transition: transition)
    }
    
}

private extension MainCoordinator {
    // Перенести во viewModel onBoarding
    func createStockShortcuts() {
        //setup shortcuts
        let shortcutService: ShortcutListDataSource = AppDI.resolve()
        
        shortcutService.addShortcut(for: Shortcut(name: R.string.localizable.stock_SHORTCUT_HOME(), color: R.color.shortcutDetail.colorSelection.green()!.toHexString()))
        shortcutService.addShortcut(for: Shortcut(name: R.string.localizable.stock_SHORTCUT_WORK(), color: R.color.shortcutDetail.colorSelection.red()!.toHexString()))
        shortcutService.addShortcut(for: Shortcut(name: R.string.localizable.stock_SHORTCUT_SHOPING(), color: R.color.shortcutDetail.colorSelection.orange()!.toHexString()))
        shortcutService.addShortcut(for: Shortcut(name: R.string.localizable.stock_SHORTCUT_ROUTINE(), color: R.color.shortcutDetail.colorSelection.blue()!.toHexString()))
        shortcutService.addShortcut(for: Shortcut(name: R.string.localizable.stock_SHORTCUT_IDEAS(), color: R.color.shortcutDetail.colorSelection.lightBlue()!.toHexString()))
    }
}
