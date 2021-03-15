//
//  TaskDeleteViewModel.swift
//  DoTask
//
//  Created by KLuV on 07.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

class TaskDeleteViewModel: DetailTaskTableItemViewModelType, TaskDeleteViewModelType, TaskDeleteViewModelInputs {
    
    private var askFordeleteTaskHandler: () -> Void
    
    var inputs: TaskDeleteViewModelInputs { return self }
    
    init(askFordeleteTaskHandler: @escaping () -> Void) {
        self.askFordeleteTaskHandler = askFordeleteTaskHandler
    }
    
    // MARK: Inputs
    
    func askForDelete() {
        askFordeleteTaskHandler()
    }
    
}
