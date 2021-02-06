//
//  Calendar.swift
//  Tasker
//
//  Created by kluv on 06/10/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import Foundation

extension Calendar {
    
    var taskCalendar: Calendar {
        get {
            let calendar = Calendar(identifier: .iso8601)
            return calendar
        }
    }
    
}
