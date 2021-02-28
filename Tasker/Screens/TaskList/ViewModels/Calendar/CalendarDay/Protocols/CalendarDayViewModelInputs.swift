//
//  CalendarDayViewModelInputs.swift
//  Tasker
//
//  Created by KLuV on 17.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol CalendarDayViewModelInputs {
    func setSelectDay(selected: Bool)
    func setDayWithTask(haveTasks: Bool)
}
