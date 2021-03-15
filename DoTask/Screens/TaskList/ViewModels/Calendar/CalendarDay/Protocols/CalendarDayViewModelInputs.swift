//
//  CalendarDayViewModelInputs.swift
//  DoTask
//
//  Created by KLuV on 17.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol CalendarDayViewModelInputs {
    func setSelectDay(selected: Bool)
    func setDayStatus(status: CalendarDayStatus)
}
