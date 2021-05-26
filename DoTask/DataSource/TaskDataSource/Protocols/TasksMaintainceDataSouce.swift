//
//  TasksMaintainceDataSouce.swift
//  DoTask
//
//  Created by Sergio Lechini on 25.05.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol TasksMaintainceDataSource {
    func transferOverdueTasks()
    func getAllTasks() -> [Task]
}
