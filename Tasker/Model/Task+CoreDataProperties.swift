//
//  Task+CoreDataProperties.swift
//  Tasker
//
//  Created by kluv on 27/09/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var identificator: UUID
    @NSManaged public var lat: Double
    @NSManaged public var lon: Double
    @NSManaged public var reminderDate: Bool
    @NSManaged public var reminderGeo: Bool
    @NSManaged public var taskDate: Date?
    @NSManaged public var title: String?
    
    @objc var dailyName: String? {
        
        var dailyTitle = ""
        
        if let taskDate = self.taskDate {
            let isCurrentDay = Calendar.current.isDateInToday(taskDate)
            let isTomorrowDay = Calendar.current.isDateInTomorrow(taskDate)
            
            if isCurrentDay {
                dailyTitle = "TODAY"
            } else if isTomorrowDay {
                dailyTitle = "TOMORROW"
            } else {
                let currentDay = Date()
                if Calendar.current.isDate(taskDate, equalTo: currentDay, toGranularity: .weekOfYear) {
                    dailyTitle = "CURRENT WEEK"
                } else {
                    dailyTitle = "LATER"
                }
            }
        } else {
            dailyTitle = "LATER"
        }
        
        return dailyTitle
        
    }
    
}
