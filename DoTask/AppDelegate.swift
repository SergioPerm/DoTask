//
//  AppDelegate.swift
//  DoTask
//
//  Created by kluv on 27/09/2020.x
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit
import CoreData

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
        
        do {
            try R.validate()
        } catch {
            fatalError()
        }
        
        PushNotificationService.shared.checkAuthorization()

        let router = Router(rootViewController: UIViewController())
        coordinator = MainCoordinator(presenter: router)
        coordinator?.start()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        
        window?.rootViewController = router.rootViewController
        window?.makeKeyAndVisible()
         
        return true
    }
}

