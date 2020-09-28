//
//  TaskListDataSourceAssembler.swift
//  Tasker
//
//  Created by kluv on 27/09/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

class TaskListDataSourceAssembler {
    static func createInstance() -> TaskListDataSource {
        TaskListDataSourceCoreDataImpl(context: CoreDataService.shared.context)
    }
}
