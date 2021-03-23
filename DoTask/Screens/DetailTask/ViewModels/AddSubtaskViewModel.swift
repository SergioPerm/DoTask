//
//  AddSubtaskViewModel.swift
//  DoTask
//
//  Created by Сергей Лепинин on 23.03.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

class AddSubtaskViewModel: DetailTaskTableItemViewModelType, AddSubtaskViewModelType, AddSubtaskViewModelInputs {
    
    private var addSubtaskHandler: () -> Void
    
    var inputs: AddSubtaskViewModelInputs { return self }
    
    init(addSubtaskHandler: @escaping () -> Void) {
        self.addSubtaskHandler = addSubtaskHandler
    }
    
    // MARK: Inputs
    
    func addSubtask() {
        addSubtaskHandler()
    }
    
}
