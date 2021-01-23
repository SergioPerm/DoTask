//
//  CalendarPickerAssembly.swift
//  Tasker
//
//  Created by kluv on 23/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import Foundation

class CalendarPickerAssembly {
    static func createInstance(date: Date?, presenter: RouterType?) -> CalendarPickerViewController {
        let viewModel: CalendarPickerViewModelType = CalendarPickerViewModel(selectedDate: date)
        return CalendarPickerViewController(selectedDate: date, viewModel: viewModel, presenter: presenter, presentableControllerViewType: .containerChild)
    }
}
