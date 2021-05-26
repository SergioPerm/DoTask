//
//  SpotlightService.swift
//  DoTask
//
//  Created by Sergio Lechini on 26.05.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation
import CoreSpotlight
import MobileCoreServices

protocol SpotlightTasksService {
    func addTask(task: Task)
    func updateTask(task: Task)
    func deleteTask(task: Task)
    
    func deleteAllTasks()
}

enum SpotlightDomainIdentifiers: String {
    case Tasks = "com.itotdel.DoTask.Tasks"
}

class SpotlightService {
    
    private let localizeService: LocalizeServiceType
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        return dateFormatter
    }()
    
    init(localizeService: LocalizeServiceType) {
        self.localizeService = localizeService
    }
    
    private func createSearchableItem(domainID: String, spotlightUID: String, title: String, description: String, keywords: [String]) -> CSSearchableItem {
        let searchableItemAttributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
        searchableItemAttributeSet.title = title
        searchableItemAttributeSet.contentDescription = description
        searchableItemAttributeSet.keywords = keywords
        
        return CSSearchableItem(uniqueIdentifier: spotlightUID, domainIdentifier: domainID, attributeSet: searchableItemAttributeSet)
    }
    
    private func indexSearchableItems(items: [CSSearchableItem]) {
        CSSearchableIndex.default().indexSearchableItems(items) { error in
            if let error = error {
                print("Spotlight error: \(error.localizedDescription)")
            }
        }
    }
    
    private func deleteSearchableItem(spotlightUID: String) {
        CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: [spotlightUID]) { error in
            if let error = error {
                print("Spotlight error: \(error.localizedDescription)")
            }
        }
    }
    
    private func deleteAllItemsByDomainIdentifier(domainIdentifier: String) {
        CSSearchableIndex.default().deleteSearchableItems(withDomainIdentifiers: [domainIdentifier], completionHandler: nil)
    }
    
}

extension SpotlightService: SpotlightTasksService {
    func addTask(task: Task) {
        
        let currentLocal = localizeService.currentLocal?.rawValue ?? "en"
        
        let taskMainTitle = task.isDone ? localizeService.localizeString(forKey: "TASK_DONE_STATUS", locale: currentLocal) : localizeService.localizeString(forKey: "TASK_PROGRESS_STATUS", locale: currentLocal)
        var taskDateTitle = localizeService.localizeString(forKey: "WITHOUT_DATE", locale: currentLocal)
        
        if let taskDate = task.taskDate {
            let dateFormat = "EE, dd MMM yyyy"
            dateFormatter.locale = Locale(identifier: currentLocal)
            dateFormatter.setLocalizedDateFormatFromTemplate(dateFormat)
            taskDateTitle = dateFormatter.string(from: taskDate).capitalizingFirstLetter()
        }
        
        let taskTitle = String(task.title.prefix(30))
        let taskDescription = "\(taskMainTitle) \(taskDateTitle)"
        
        let item = createSearchableItem(domainID: SpotlightDomainIdentifiers.Tasks.rawValue, spotlightUID: task.uid, title: taskTitle, description: taskDescription, keywords: [task.title])
        indexSearchableItems(items: [item])
    }
    
    func updateTask(task: Task) {
        deleteSearchableItem(spotlightUID: task.uid)
        addTask(task: task)
    }
    
    func deleteTask(task: Task) {
        deleteSearchableItem(spotlightUID: task.uid)
    }
    
    func deleteAllTasks() {
        deleteAllItemsByDomainIdentifier(domainIdentifier: SpotlightDomainIdentifiers.Tasks.rawValue)
    }
}
