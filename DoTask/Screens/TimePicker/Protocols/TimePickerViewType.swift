//
//  TimePickerViewType.swift
//  DoTask
//
//  Created by Сергей Лепинин on 02.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol TimePickerViewType: PresentableController {
    var deleteReminderHandler: (() -> Void)? { get set }
    var setReminderHandler: ((_ setTime: Date) -> Void)? { get set }
    
    func setBaseTime(time: Date?)
}
