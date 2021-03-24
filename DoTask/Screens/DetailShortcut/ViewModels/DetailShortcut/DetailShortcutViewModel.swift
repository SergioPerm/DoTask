//
//  DetailShortcutViewModel.swift
//  DoTask
//
//  Created by KLuV on 05.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

class DetailShortcutViewModel: DetailShortcutViewModelType, DetailShortcutViewModelInputs, DetailShortcutViewModelOutputs {
    
    private var shortcut: Shortcut
    private var dataSource: ShortcutListDataSource

    private var presetColors: [String] = [
        R.color.shortcutDetail.colorSelection.lightBlue()!.toHexString(),
        R.color.shortcutDetail.colorSelection.dullPurple()!.toHexString(),
        R.color.shortcutDetail.colorSelection.pink()!.toHexString(),
        R.color.shortcutDetail.colorSelection.yellow()!.toHexString(),
        R.color.shortcutDetail.colorSelection.green()!.toHexString(),
        R.color.shortcutDetail.colorSelection.red()!.toHexString(),
        R.color.shortcutDetail.colorSelection.orange()!.toHexString(),
        R.color.shortcutDetail.colorSelection.purple()!.toHexString(),
        R.color.shortcutDetail.colorSelection.lightGreen()!.toHexString(),
        R.color.shortcutDetail.colorSelection.dullPurple()!.toHexString(),
        R.color.shortcutDetail.colorSelection.dullGreen()!.toHexString(),
        R.color.shortcutDetail.colorSelection.darkBlue()!.toHexString(),
        R.color.shortcutDetail.colorSelection.blue()!.toHexString(),
        R.color.shortcutDetail.colorSelection.black()!.toHexString(),
        R.color.shortcutDetail.colorSelection.brown()!.toHexString(),
        R.color.shortcutDetail.colorSelection.dullPink()!.toHexString(),
        R.color.shortcutDetail.colorSelection.dullRed()!.toHexString(),
        R.color.shortcutDetail.colorSelection.green()!.toHexString(),
        R.color.shortcutDetail.colorSelection.silver()!.toHexString()
    ]
    
    var inputs: DetailShortcutViewModelInputs { return self }
    var outputs: DetailShortcutViewModelOutputs { return self }

    init(shortcutUID: String?, dataSource: ShortcutListDataSource) {
        self.shortcut = dataSource.shortcutByIdentifier(identifier: shortcutUID) ?? Shortcut()
        self.dataSource = dataSource
        
        if self.shortcut.isNew {
            self.shortcut.color = presetColors[2]
        }
        
        self.selectedColor = Observable(shortcut.color)
        
        self.title = shortcut.name
    }
    
    // MARK: Inputs
    
    func setColor(colorHex: String) {
        shortcut.color = colorHex
        selectedColor.value = colorHex
    }

    func setTitle(title: String) {
        shortcut.name = title
    }

    func toggleshowInMainListSetting() {
        shortcut.showInMainList = !shortcut.showInMainList
    }
    
    func save() {
        if shortcut.isNew {
            dataSource.addShortcut(for: shortcut)
        } else {
            dataSource.updateShortcut(for: shortcut)
        }
    }
    
    func delete() {
        if !shortcut.isNew {
            dataSource.deleteShortcut(for: shortcut)
        }
    }

    // MARK: OUTPUTS
    
    var selectedColor: Observable<String>
    var title: String
    var showInMainListSetting: Bool {
        return shortcut.showInMainList
    }
    
    func getAllColors() -> [ColorSelectionItemViewModelType] {
        var colorViewModels: [ColorSelectionItemViewModelType] = []
        
        presetColors.forEach {
            let colorViewModel = ColorSelectionItemViewModel(hexColor: $0)
            
            if !shortcut.isNew {
                if shortcut.color == $0 {
                    colorViewModel.inputs.setSelected(selected: true)
                }
            }
            
            colorViewModels.append(colorViewModel)
        }
        
        return colorViewModels
    }
    
    var isNew: Bool {
        return shortcut.isNew
    }
}
