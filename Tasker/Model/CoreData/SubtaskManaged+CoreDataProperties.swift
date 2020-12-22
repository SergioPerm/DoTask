//
//  Subtask+CoreDataProperties.swift
//  Tasker
//
//  Created by KLuV on 22.12.2020.
//  Copyright © 2020 itotdel. All rights reserved.
//
//

import Foundation
import CoreData


extension SubtaskManaged {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SubtaskManaged> {
        return NSFetchRequest<SubtaskManaged>(entityName: "SubtaskManaged")
    }

    @NSManaged public var isDone: Bool
    @NSManaged public var title: String
    @NSManaged public var priority: Int16
    @NSManaged public var task: TaskManaged
    
}
