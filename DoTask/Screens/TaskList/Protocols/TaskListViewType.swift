//
//  TaskListViewType.swift
//  DoTask
//
//  Created by Сергей Лепинин on 01.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

protocol TaskListViewType: PresentableController {
    var filter: TaskListFilter? { get set }
    var slideMenu: SlideMenuViewType? { get set }
    var editTaskAction: ((_ taskUID: String?, _ shortcutUID: String?, _ taskDate: Date?) ->  Void)? { get set }
    var speechTaskAction: ((_ recognizer: UILongPressGestureRecognizer, _ shortcutUID: String?, _ taskDate: Date?) ->  Void)? { get set }
}
