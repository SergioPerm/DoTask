//
//  AppDelegate.swift
//  DoTask
//
//  Created by kluv on 27/09/2020.x
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit
import CoreData
import DITranquillity
import CoreSpotlight
import MobileCoreServices

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var coordinator: MainCoordinator?
    var window: UIWindow?
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
         
        let path = FileManager
            .default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)
            .last?
            .absoluteString
            .replacingOccurrences(of: "file://", with: "")
            .removingPercentEncoding

        print("Core Data DB Path :: \(path ?? "Not found")")
                
        AppDI.reg()
        
        #if DEBUG
        do {
            try R.validate()
        } catch {
            fatalError()
        }
        #endif
        
//        let pushNotificationService: PushNotificationService = AppDI.resolve()
//        pushNotificationService.checkAuthorization()
        
//        let dataSource: TaskListDataSourceCoreData = AppDI.resolve()
//        dataSource.clearData()
        
        let router: RouterType = AppDI.resolve()
        coordinator = AppDI.resolve()
        coordinator?.start(finishCompletion: nil)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        
        window?.rootViewController = router.rootViewController
        window?.makeKeyAndVisible()
                        
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
     
        if userActivity.activityType == CSSearchableItemActionType {
            if let userInfo = userActivity.userInfo {
                if let selectedID = userInfo[CSSearchableItemActivityIdentifier] as? String {
                    coordinator?.editTask(taskUID: selectedID, shortcutUID: nil, taskDate: nil)
                }
            }
        }
        
        return true
    }
}

