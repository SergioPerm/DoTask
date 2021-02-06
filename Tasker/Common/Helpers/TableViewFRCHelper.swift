//
//  TableViewFRCHelper.swift
//  Tasker
//
//  Created by KLuV on 04.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol TableViewFRCHelperDelegate: class {
    func deleteItem(indexPath: IndexPath)
    func addSection(indexPath: IndexPath)
    func addItem(indexPath: IndexPath)
}

class TableViewFRCHelper {
    private var tableChanges: [TableChange] = []
    
    enum ChangeType: Int {
        case deleteItem
        case insertSection
        case insertItem
    }
    
    struct TableChange {
        
        let changeType: ChangeType
        let indexPath: IndexPath
        
        init(changeType: ChangeType, indexPath: IndexPath) {
            self.changeType = changeType
            self.indexPath = indexPath
        }
    }
        
    weak var delegate: TableViewFRCHelperDelegate?
    
    func addTableChange(changeType: ChangeType, indexPath: IndexPath) {
        tableChanges.append(TableChange(changeType: changeType, indexPath: indexPath))
    }
    
    func applyChanges() {
        tableChanges.sort {
            $0.changeType.rawValue < $1.changeType.rawValue
        }
        
        tableChanges.forEach { tableChange in
            switch tableChange.changeType {
            case .deleteItem:
                delegate?.deleteItem(indexPath: tableChange.indexPath)
            case .insertSection:
                delegate?.addSection(indexPath: tableChange.indexPath)
            case .insertItem:
                delegate?.addItem(indexPath: tableChange.indexPath)
            }
        }
        
        tableChanges.removeAll()
    }
}
