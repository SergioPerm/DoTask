//
//  SubtasksTableView.swift
//  Tasker
//
//  Created by KLuV on 27.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class SubtasksTableView: UITableView {
    private var reloadDataCompletionBlock: (() -> Void)?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        reloadDataCompletionBlock?()
        reloadDataCompletionBlock = nil
    }
    
    
    func reloadDataWithCompletion(completion: @escaping () -> Void) {
        reloadDataCompletionBlock = completion
        self.reloadData()
    }
}
