//
//  DatePickerDependency.swift
//  DoTask
//
//  Created by Сергей Лепинин on 02.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation
import DITranquillity

class DatePickerDependency: DIPart {
    static func load(container: DIContainer) {
        container.register(CalendarPickerViewModel.init).as(CalendarPickerViewModelType.self)
        container.register{
            CalendarPickerViewController(viewModel: $0, router: $1, presentableControllerViewType: .presentWithTransition)
        }.as(CalendarPickerViewType.self)
    }
}
