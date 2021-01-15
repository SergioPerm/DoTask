//
//  ShortcutListViewModel.swift
//  Tasker
//
//  Created by KLuV on 12.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

class ShortcutListViewModel: ShortcutListViewModelType, ShortcutListViewModelInputs, ShortcutListViewModelOutputs {

    private var dataSource: ShortcutListDataSource
    private var shortcutNameFilter: String = ""
    
    var inputs: ShortcutListViewModelInputs { return self }
    var outputs: ShortcutListViewModelOutputs { return self }
    
    init(dataSource: ShortcutListDataSource) {
        self.dataSource = dataSource
    }
    
    // MARK: Inputs
    
    func setFilter(shortcutNameFilter: String) {
        self.shortcutNameFilter = shortcutNameFilter
    }
    
    // MARK: Outputs
    
    var shortcuts: [ShortcutViewModelType] {
        var allShortcuts: [ShortcutViewModelType] = dataSource.shortcuts.map({
            ShortcutViewModel(shortcut: $0)
        })
        
        if !shortcutNameFilter.isEmpty {
            allShortcuts = allShortcuts.filter({
                $0.outputs.title.uppercased().contains(shortcutNameFilter.uppercased())
            })
        }
        
        return allShortcuts
    }
}
