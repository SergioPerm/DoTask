//
//  NotificationsDependency.swift
//  DoTask
//
//  Created by Сергей Лепинин on 03.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation
import DITranquillity

class NotificationDependency: DIPart {
    static func load(container: DIContainer) {
        container.register(PushNotificationService.init).lifetime(.perRun(.strong))
    }
}
