//
//  CalendarDayViewModelType.swift
//  DoTask
//
//  Created by KLuV on 17.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol CalendarDayViewModelType {
    var inputs: CalendarDayViewModelInputs { get }
    var outputs: CalendarDayViewModelOutputs { get }
    
    //func unbind()
}
