//
//  TaskDiaryViewPresentable.swift
//  Tasker
//
//  Created by KLuV on 05.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol TaskDiaryViewPresentable: PresentableController {
    var editTaskAction: ((_ taskUID: String?, _ shortcutUID: String?) ->  Void)? { get set }
}
