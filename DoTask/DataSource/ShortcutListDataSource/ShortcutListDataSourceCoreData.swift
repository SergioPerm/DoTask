//
//  ShortcutListDataSourceCoreData.swift
//  DoTask
//
//  Created by KLuV on 07.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import CoreData

class ShortcutListDataSourceCoreData: NSObject {
    
    // MARK: - Dependencies
    private let context: NSManagedObjectContext
    
    // MARK: - Properites
    weak var observer: ShortcutListDataSourceObserver?
    private let fetchedResultsController: NSFetchedResultsController<ShortcutManaged>
    
    init(context: NSManagedObjectContext) {
        self.context = context
        
        // Setting up fetchedResultsController
        let fetchRequest: NSFetchRequest<ShortcutManaged> = ShortcutManaged.fetchRequest()
                
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
                
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchBatchSize = 20
        // Initialize Fetched Results Controller
        self.fetchedResultsController = NSFetchedResultsController<ShortcutManaged>(fetchRequest: fetchRequest, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        
        fetchedResultsController.delegate = self
    }
    
}

extension ShortcutListDataSourceCoreData: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        observer?.shortcutWillChange()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        observer?.shortcutDidChange()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        
        case .insert:
            if let indexPath = newIndexPath {
                observer?.shortcutInserted(at: indexPath)
            }
        case .delete:
            if let indexPath = indexPath {
                observer?.shortcutDeleted(at: indexPath)
            }
        case .move:
            if let indexPath = indexPath {
                observer?.shortcutDeleted(at: indexPath)
            }
            if let indexPath = newIndexPath {
                observer?.shortcutInserted(at: indexPath)
            }
        case .update:
            if let indexPath = indexPath {
                observer?.shortcutUpdated(at: indexPath)
            }
        default:
            break
        }
    }
}

// MARK: ShortcutListDataSource

extension ShortcutListDataSourceCoreData: ShortcutListDataSource {
    var shortcuts: [Shortcut] {
        if let fetchedShortcuts = fetchedResultsController.fetchedObjects {
            return fetchedShortcuts.map {
                return Shortcut(with: $0)
            }
        } else {
            return fetchShortcuts().map {
                return Shortcut(with: $0)
            }
        }
    }
    
    func addShortcut(for shortcut: Shortcut) {
        let newShortcut = ShortcutManaged(context: context)
        
        if let uuid: UUID = UUID(uuidString: shortcut.uid) {
            
            newShortcut.identificator = uuid
            newShortcut.name = shortcut.name.trimmingCharacters(in: .whitespacesAndNewlines)
            newShortcut.color = shortcut.color
            newShortcut.showInMainList = shortcut.showInMainList
            
            do {
                try context.save()

            } catch {
                fatalError()
            }
        }
    }
    
    func updateShortcut(for shortcut: Shortcut) {
        if let shortcutManaged = shortcutManagedByIdentifier(identifier: shortcut.uid) {
            shortcutManaged.name = shortcut.name.trimmingCharacters(in: .whitespacesAndNewlines)
            shortcutManaged.color = shortcut.color
            shortcutManaged.showInMainList = shortcut.showInMainList
            
            do {
                try context.save()

            } catch {
                fatalError()
            }
        }
    }
    
    func deleteShortcut(for shortcut: Shortcut) {
        if let shortcutManaged = shortcutManagedByIdentifier(identifier: shortcut.uid) {
            context.delete(shortcutManaged)
            
            do {
                try context.save()

            } catch {
                fatalError()
            }
        }
    }
    
    func shortcutByIdentifier(identifier: String?) -> Shortcut? {
        guard let identifier = identifier else { return nil }
        if let uuid = UUID(uuidString: identifier) {
            let fetchRequest: NSFetchRequest<ShortcutManaged> = NSFetchRequest(entityName: "ShortcutManaged")
            let predicate = NSPredicate(format: "identificator == %@", uuid as NSUUID)

            fetchRequest.predicate = predicate
            
            do {
                let shortcuts = try context.fetch(fetchRequest)
                
                if shortcuts.isEmpty {
                    return nil
                }
                
                return Shortcut(with: shortcuts[0])
            } catch {
                fatalError()
            }
        }
        
        return nil
    }
    
    func clearData() {
        let fetchRequest: NSFetchRequest<ShortcutManaged> = ShortcutManaged.fetchRequest()

        do {
            let shortcutsForDelete = try context.fetch(fetchRequest)
            for shortcut in shortcutsForDelete {
                context.delete(shortcut)
            }
        } catch {
            fatalError()
        }
        
        do {
            try context.save()
        } catch {
            fatalError()
        }
    }
}

// MARK: Utils

extension ShortcutListDataSourceCoreData {
    private func fetchShortcuts() -> [ShortcutManaged] {
        do {
            try fetchedResultsController.performFetch()
            return fetchedResultsController.fetchedObjects ?? []
        } catch {
            fatalError()
        }
    }
    
    private func shortcutManagedByIdentifier(identifier: String?) -> ShortcutManaged? {
        guard let identifier = identifier else { return nil }
        if let uuid = UUID(uuidString: identifier) {
            let fetchRequest: NSFetchRequest<ShortcutManaged> = ShortcutManaged.fetchRequest()
            let predicate = NSPredicate(format: "identificator == %@", uuid as NSUUID)
            
            fetchRequest.predicate = predicate
            
            do {
                let shortcuts = try context.fetch(fetchRequest)
                
                if shortcuts.isEmpty {
                    return nil
                }
                
                return shortcuts[0]
            } catch {
                fatalError()
            }
        }
        
        return nil
    }
}

