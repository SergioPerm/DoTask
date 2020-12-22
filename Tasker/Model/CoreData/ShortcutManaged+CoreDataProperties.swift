//
//  Shortcut+CoreDataProperties.swift
//  Tasker
//
//  Created by KLuV on 04.12.2020.
//  Copyright © 2020 itotdel. All rights reserved.
//
//

import Foundation
import CoreData


extension ShortcutManaged {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShortcutManaged> {
        return NSFetchRequest<ShortcutManaged>(entityName: "ShortcutManaged")
    }

    @NSManaged public var color: String
    @NSManaged public var name: String
    @NSManaged public var tasks: NSSet

}

// MARK: Generated accessors for tasks
extension ShortcutManaged {

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: TaskManaged)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: TaskManaged)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)

}
