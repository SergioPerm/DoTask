//
//  AppDelegate.swift
//  Tasker
//
//  Created by kluv on 27/09/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        PushNotificationService.shared.checkAuthorization()

        let container = ContainerViewController()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = container
        window?.makeKeyAndVisible()
        
        return true
    }
}

