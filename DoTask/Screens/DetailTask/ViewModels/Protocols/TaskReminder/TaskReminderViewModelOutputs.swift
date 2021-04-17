//
//  TaskReminderInfoViewModelOutputs.swift
//  DoTask
//
//  Created by KLuV on 01.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol TaskReminderViewModelOutputs {
    var timeInfo: Observable<Date?> { get }
}
