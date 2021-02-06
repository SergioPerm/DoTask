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

extension TaskManaged {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskManaged> {
        return NSFetchRequest<TaskManaged>(entityName: "TaskManaged")
    }

    @NSManaged public var identificator: UUID
    @NSManaged public var lat: Double
    @NSManaged public var lon: Double
    @NSManaged public var reminderDate: Bool
    @NSManaged public var reminderGeo: Bool
    @NSManaged public var taskDate: Date?
    @NSManaged public var doneDate: Date?
    @NSManaged public var title: String?
    @NSManaged public var isDone: Bool
    @NSManaged public var importanceLevel: Int16
    @NSManaged public var mainTaskListOrder: Int16
    @NSManaged public var shortcut: ShortcutManaged?
    @NSManaged public var subtasks: NSSet
    
    @objc var dailyName: String? {
        guard let taskDate = self.taskDate else {
            return "LATER"
        }
        
        return taskDate.dailyNameForTask()
    }
    
    @objc var doneDay: Date? {
        if let doneDate = self.doneDate {
            return doneDate.startOfDay()
        }
        
        return Date().startOfDay()
    }
    
}

// MARK: Generated accessors for subtasks
extension TaskManaged {

    @objc(addSubtasksObject:)
    @NSManaged public func addToSubtasks(_ value: SubtaskManaged)

    @objc(removeSubtasksObject:)
    @NSManaged public func removeFromSubtasks(_ value: SubtaskManaged)

    @objc(addSubtasks:)
    @NSManaged public func addToSubtasks(_ values: NSSet)

    @objc(removeSubtasks:)
    @NSManaged public func removeFromSubtasks(_ values: NSSet)

}
