//
//  TaskListView.swift
//  DoTask
//
//  Created by kluv on 27/09/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import Foundation

protocol TaskListViewObservable: AnyObject {
    // TableView
    func tableViewReload()
    func tableViewBeginUpdates()
    func tableViewInsertRow(at newIndexPath: IndexPath)
    func tableViewDeleteRow(at indexPath: IndexPath)
    func tableViewSectionInsert(at indexSet: IndexSet)
    func tableViewSectionDelete(at indexSet: IndexSet)
    func tableViewEndUpdates()
    
    func editTask(taskUID: String)
}
