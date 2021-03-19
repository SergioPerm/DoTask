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
        R.color.shortcutDetail.lightBlue()!.toHexString(),
        R.color.shortcutDetail.dullPurple()!.toHexString(),
        R.color.shortcutDetail.pink()!.toHexString(),
        R.color.shortcutDetail.yellow()!.toHexString(),
        R.color.shortcutDetail.green()!.toHexString(),
        R.color.shortcutDetail.red()!.toHexString(),
        R.color.shortcutDetail.orange()!.toHexString(),
        R.color.shortcutDetail.purple()!.toHexString(),
        R.color.shortcutDetail.lightGreen()!.toHexString(),
        R.color.shortcutDetail.dullPurple()!.toHexString(),
        R.color.shortcutDetail.dullGreen()!.toHexString(),
        R.color.shortcutDetail.darkBlue()!.toHexString(),
        R.color.shortcutDetail.blue()!.toHexString(),
        R.color.shortcutDetail.black()!.toHexString(),
        R.color.shortcutDetail.brown()!.toHexString(),
        R.color.shortcutDetail.dullPink()!.toHexString(),
        R.color.shortcutDetail.dullRed()!.toHexString(),
        R.color.shortcutDetail.green()!.toHexString(),
        R.color.shortcutDetail.silver()!.toHexString()
    ]
    
    var inputs: DetailShortcutViewModelInputs { return self }
    var outputs: DetailShortcutViewModelOutputs { return self }

    init(shortcutUID: String?, dataSource: ShortcutListDataSource) {
        self.shortcut = dataSource.shortcutByIdentifier(identifier: shortcutUID) ?? Shortcut()
        self.dataSource = dataSource
        
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
