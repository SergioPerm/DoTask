//
//  TableViewFRCHelper.swift
//  DoTask
//
//  Created by KLuV on 04.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol TableViewFRCHelperDelegate: AnyObject {
    func addItem(indexPath: IndexPath)
    func deleteItem(indexPath: IndexPath)
    func addSection(indexPath: IndexPath)
    func deleteSection(indexPath: IndexPath)
    func updateItem(indexPath: IndexPath)
}

class TableViewFRCHelper {
    private var tableChanges: [TableChange] = []
    
    enum ChangeType: Int {
        case deleteItem
        case insertItem
        case insertSection
        case deleteSection
        case update
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
            if $0.changeType.rawValue != $1.changeType.rawValue {
                return $0.changeType.rawValue < $1.changeType.rawValue
            } else if $0.indexPath.section != $1.indexPath.section {
                return $0.indexPath.section < $1.indexPath.section
            } else {
                return $0.indexPath.row < $1.indexPath.row
            }
        }
        
        tableChanges.forEach { tableChange in
            switch tableChange.changeType {
            case .deleteItem:
                delegate?.deleteItem(indexPath: tableChange.indexPath)
            case .insertSection:
                delegate?.addSection(indexPath: tableChange.indexPath)
            case .insertItem:
                delegate?.addItem(indexPath: tableChange.indexPath)
            case .deleteSection:
                delegate?.deleteSection(indexPath: tableChange.indexPath)
            case .update:
                delegate?.updateItem(indexPath: tableChange.indexPath)
            }
        }
        
        tableChanges.removeAll()
    }
}
