//
//  TaskListViewModelAssembler.swift
//  Tasker
//
//  Created by kluv on 27/09/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

class TaskListViewModelAssembler {
    static func createInstance() -> TaskListViewModel {
        let dataSource = TaskListDataSourceAssembler.createInstance()
        return TaskListViewModel(dataSource: dataSource)
    }
}
