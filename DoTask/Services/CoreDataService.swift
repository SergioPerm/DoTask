//
//  CoreDataService.swift
//  DoTask
//
//  Created by kluv on 27/09/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import CoreData

class CoreDataService {
    static let shared = CoreDataService()

    // MARK: - Properties
    lazy var context: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: "Tasker")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container.viewContext
    }()
}

// MARK: - Exposed functions
internal extension CoreDataService {
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
