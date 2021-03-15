//
//  DetailTaskViewControllerType.swift
//  DoTask
//
//  Created by KLuV on 09.12.2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import Foundation

protocol DetailTaskViewType: PresentableController {
    var onCalendarSelect: ((_ selectedDate: Date?, _ vc: CalendarPickerViewOutputs) -> Void)? { get set }
    var onTimeReminderSelect: ((_ selectedTime: Date, _ vc: TimePickerViewOutputs) -> Void)? { get set }
    var onShortcutSelect: ((_ selectedShortcutUID: String?, _ vc: ShortcutListViewOutputs) -> Void)? { get set }
    
    var scrollView: DetailTaskScrollViewType { get }
}


