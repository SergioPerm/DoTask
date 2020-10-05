//
//  NotificationService.swift
//  Tasker
//
//  Created by kluv on 04/10/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import Foundation
import UserNotifications

class PushNotificationService: NSObject {
    
    static let shared = PushNotificationService()
    
    let notificationCenter = UNUserNotificationCenter.current()
        
    private lazy var notificationObservers = [NotificationTaskObserver]()
    
    override init() {
        super.init()
        notificationCenter.delegate = self
    }
    
    func checkAuthorization() {
        let notificationsOptions: UNAuthorizationOptions = [.alert, .sound, .badge]
         
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                self.notificationCenter.requestAuthorization(options: notificationsOptions) {
                    (didAllow, error) in
                    if !didAllow {
                        print("User has declined notifications")
                    }
                }
            }
        }
    }
    
    func addLocalNotification(notifyModel: NotifyByDateModel) {
        let content = UNMutableNotificationContent()
        
        content.title = notifyModel.title
        content.body = notifyModel.body
        content.sound = .default
        content.badge = 1
        
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

            notificationObservers.forEach({ $0.onTapNotification(with: strID)})
        }
    }
    
}
