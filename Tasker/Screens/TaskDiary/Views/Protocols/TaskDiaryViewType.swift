//
//  TaskDiaryViewType.swift
//  Tasker
//
//  Created by KLuV on 04.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol TaskDiaryViewType: class {
    func tableViewReload()
    func tableViewBeginUpdates()
    func tableViewInsertRow(at newIndexPath: IndexPath)
    func tableViewDeleteRow(at indexPath: IndexPath)
    func tableViewSectionInsert(at indexSet: IndexSet)
    func tableViewSectionDelete(at indexSet: IndexSet)
    func tableViewEndUpdates()
    
    func editTask(taskUID: String)
}
