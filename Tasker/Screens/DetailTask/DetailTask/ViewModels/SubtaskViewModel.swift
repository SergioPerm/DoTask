//
//  SubtaskViewModel.swift
//  Tasker
//
//  Created by KLuV on 22.12.2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import Foundation

class SubtaskViewModel: NSObject, SubtaskViewModelType, SubtaskViewModelInputs, SubtaskViewModelOutputs {
  
    private var subtask: Subtask
    //private weak var detailTaskViewModel: DetailTaskViewModelType?
    
    var inputs: SubtaskViewModelInputs { return self }
    var outputs: SubtaskViewModelOutputs { return self }
    
    init(subtask: Subtask) {
        self.subtask = subtask
    }
        
    // MARK: INPUTS
    
    func setDone(done: Bool) {
        subtask.isDone = done
    }
    
    func setTitle(title: String) {
        subtask.title = title
    }
    
    func setPriority(priority: Int16) {
        subtask.priority = priority
    }
        
    // MARK: OUTPUTS
    
    var isDone: Bool {
        return subtask.isDone
    }
    
    var title: String {
        return subtask.title
    }
    
    var priority: Int16 {
        return subtask.priority
    }
}
