//
//  CalendarPickerViewType.swift
//  DoTask
//
//  Created by Сергей Лепинин on 02.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol CalendarPickerViewType: PresentableController {
    var cancelDatePickerHandler: (() -> Void)? { get set }
    var saveDatePickerHandler: (() -> Void)? { get set }
    var selectedDateChangedHandler: ((Date?) -> Void)? { get set }
    
    func setSelectDay(date: Date?)
}
