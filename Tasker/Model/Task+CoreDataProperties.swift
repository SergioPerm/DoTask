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
    @NSManaged public var isDone: Bool
    
    @objc var dailyName: String? {
        guard let taskDate = self.taskDate else {
            return "LATER"
        }
        
        return taskDate.dailyNameForTask()
    }
    
}
