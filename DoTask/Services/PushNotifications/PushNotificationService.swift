//
//  NotificationService.swift
//  DoTask
//
//  Created by kluv on 04/10/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import Foundation
import UserNotifications

final class PushNotificationService: NSObject {
        
    let notificationCenter = UNUserNotificationCenter.current()
        
    private lazy var notificationObservers = [NotificationTaskObserver]()
        
    override init() {
        super.init()
        notificationCenter.delegate = self
    }
    
    func checkAuthorization(completion: ((_ didAllow: Bool) -> ())? = nil) {
        let notificationsOptions: UNAuthorizationOptions = [.alert, .sound, .badge]
         
        notificationCenter.getNotificationSettings { (settings) in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.notificationCenter.requestAuthorization(options: notificationsOptions) {
                    (didAllow, error) in
                    if let completion = completion {
                        DispatchQueue.main.async {
                            completion(didAllow)
                        }
                    }
                }
            case .denied:
                self.notificationCenter.requestAuthorization(options: notificationsOptions) {
                    (didAllow, error) in
                    if let completion = completion {
                        DispatchQueue.main.async {
                            completion(didAllow)
                        }
                    }
                }
            case .authorized:
                if let completion = completion {
                    DispatchQueue.main.async {
                        completion(true)
                    }
                }
            case .provisional:
                if let completion = completion {
                    DispatchQueue.main.async {
                        completion(true)
                    }
                }
            case .ephemeral:
                if let completion = completion {
                    DispatchQueue.main.async {
                        completion(true)
                    }
                }
            @unknown default:
                if let completion = completion {
                    DispatchQueue.main.async {
                        completion(false)
                    }
                }
            }
        }
    }
    
    func addLocalNotification(notifyModel: DateNotifier) {
        let content = UNMutableNotificationContent()
        
        content.title = notifyModel.title
        content.body = notifyModel.body
        content.sound = .default
        content.badge = 1
        content.categoryIdentifier = "DOTASK_NOTIFYTASK"
        
        let triggerDate = notifyModel.dateTrigger
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let identifier = notifyModel.identifier
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    func deleteLocalNotifications(identifiers: [String]) {
        notificationCenter.removeDeliveredNotifications(withIdentifiers: identifiers)
        notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
    
    func attachObserver(_ observer: NotificationTaskObserver) {
        notificationObservers.append(observer)
    }
    
    func registerCategories() {
        let doneAction = UNNotificationAction(identifier: "DONE", title: "Done", options: .foreground)
        let remindAction = UNNotificationAction(identifier: "REMIND", title: "Remind in 30 minutes", options: .foreground)
        let taskNotifyCategory = UNNotificationCategory(identifier: "DOTASK_NOTIFYTASK", actions: [doneAction, remindAction], intentIdentifiers: [])
        
        notificationCenter.setNotificationCategories([taskNotifyCategory])
    }
        
}

extension PushNotificationService: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.badge,.sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
                
        let notifyRequest = response.notification.request
        let identifier = notifyRequest.identifier
        
        if identifier.contains("calendar_") {
            
            let index = identifier.index(identifier.endIndex, offsetBy: -36)
            let strID = String(identifier[index...])

            switch response.actionIdentifier {
            case "DONE":
                notificationObservers.forEach({ $0.setDone(with: strID)})
                completionHandler()
            case "REMIND":
                print("sdf")
                completionHandler()
            default:
                notificationObservers.forEach({ $0.onTapNotification(with: strID)})
            }
            
            
        }
    }
    
}
