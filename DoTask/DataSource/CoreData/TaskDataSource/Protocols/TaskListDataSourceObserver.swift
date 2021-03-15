//
//  TaskListDataSourceObserver.swift
//  DoTask
//
//  Created by kluv on 27/09/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import Foundation

protocol TaskListDataSourceObserver: class {
    func tasksWillChange()
    func tasksDidChange()
    func taskInserted(at newIndexPath: IndexPath)
    func taskDeleted(at indexPath: IndexPath)
    func taskUpdated(at indexPath: IndexPath)
    func taskSectionDelete(section: Int)
    func taskSectionInsert(section: Int)
}
