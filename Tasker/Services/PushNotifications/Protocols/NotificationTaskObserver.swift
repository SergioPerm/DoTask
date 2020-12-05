//
//  NotificationObserver.swift
//  Tasker
//
//  Created by kluv on 05/10/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import Foundation

protocol NotificationTaskObserver {
    func onTapNotification(with id: String)
}
