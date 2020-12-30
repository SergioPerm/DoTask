//
//  SubtasksTableViewDataSource.swift
//  Tasker
//
//  Created by KLuV on 23.12.2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

class SubtasksTableViewDataSource: NSObject, UITableViewDataSource {
    
    private var subtasks: [SubtaskViewModelType]
    private var parentScrollView: UIScrollView
    private var lowerLimitToScroll: CGFloat
    
    init(subtasks: [SubtaskViewModelType], parentScrollView: UIScrollView, lowerLimitToScroll: CGFloat) {
        self.parentScrollView = parentScrollView
        self.lowerLimitToScroll = lowerLimitToScroll
        self.subtasks = subtasks
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subtasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "test")
        
        return cell!
    }
}
