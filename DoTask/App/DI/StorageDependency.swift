//
//  StorageDependency.swift
//  DoTask
//
//  Created by Сергей Лепинин on 01.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit
import DITranquillity

class StorageDependency: DIPart {
    static func load(container: DIContainer) {
        
        container.register(CoreDataService.init).lifetime(.perRun(.strong))
        
        container.register(ShortcutListDataSourceCoreData.init(coreDataService:))
            .as(ShortcutListDataSource.self)
            .lifetime(.prototype)
        
        container.register(TaskListDataSourceCoreData.init(coreDataService:))
            .as(TaskListDataSource.self)
            .lifetime(.prototype)
        
        
    }
}
