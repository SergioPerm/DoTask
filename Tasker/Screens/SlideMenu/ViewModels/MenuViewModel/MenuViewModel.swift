//
//  MenuShortcutViewModel.swift
//  Tasker
//
//  Created by KLuV on 07.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

class MenuViewModel: MenuViewModelType, MenuViewModelInputs, MenuViewModelOutputs {
    
    private var dataSource: ShortcutListDataSource

    private let createShortcutViewModel: CreateShortcutMenuItemViewModel = CreateShortcutMenuItemViewModel()
    private var selectedViewModel: MenuItemViewModelSelectableType?
    
    var inputs: MenuViewModelInputs { return self }
    var outputs: MenuViewModelOutputs { return self }
        
    init(dataSource: ShortcutListDataSource) {
        self.tableSections = []
        self.dataSource = dataSource
        self.dataSource.observer = self
        
        setupSections()
    }
    
    // MARK: Inputs
    
    var createShortcutHandler: (() -> Void)? {
        didSet {
            createShortcutViewModel.createShortcutHandler = createShortcutHandler
        }
    }
    
    var shortcutTableView: ShortcutListTableViewType?
    
    func deleteShortcut(for shortcut: Shortcut) {
        dataSource.deleteShortcut(for: shortcut)
    }
    
    func selectShortcut(for indexPath: IndexPath) {
        if let shortcutViewModel = tableSections[indexPath.section].tableCells[indexPath.row] as? MenuItemViewModelSelectableType {
            selectedViewModel?.selectedItem.value = false
            selectedViewModel = shortcutViewModel
            selectedViewModel?.selectedItem.value = true
        }
    }
    
    // MARK: Outputs
    
    var shortcuts: [Shortcut] {
        return dataSource.shortcuts
    }
    
    var tableSections: [MenuItemSectionViewModelType]
    
}

extension MenuViewModel {
    private func setupSections() {
        let settingsSection = MenuItemSectionViewModel(cells: [SettingsMenuItemViewModel()], sectionHeight: Double.leastNormalMagnitude)

        let selectedCellViewModel = MainMenuItemViewModel(title: "Task list", imageName: "colorFlat", selected: true)
        selectedViewModel = selectedCellViewModel
                
        let mainItemsSection = MenuItemSectionViewModel(cells: [
            selectedCellViewModel,
            MainMenuItemViewModel(title: "Task diary", imageName: "diary")
        ], sectionHeight: 30)
        
        let shortcutSection = MenuItemSectionViewModel(cells: [createShortcutViewModel], sectionHeight: 10)
        
        dataSource.shortcuts.forEach {
            shortcutSection.tableCells.append(ShortcutMenuItemViewModel(shortcut: $0))
        }
        
        tableSections.append(settingsSection)
        tableSections.append(mainItemsSection)
        tableSections.append(shortcutSection)
    }
        
    private func adjustShortcutIndexPath(indexPath: IndexPath) -> IndexPath {
        // +1 - CreateShortcutCell, 2 - index of shortcut section
        return IndexPath(row: indexPath.row + 1, section: 2)
    }
    
    private func addShortcutInTable(indexPath: IndexPath) {
        let correctIndexPath = adjustShortcutIndexPath(indexPath: indexPath)
        tableSections[2].tableCells.insert(ShortcutMenuItemViewModel(shortcut: dataSource.shortcuts[indexPath.row]), at: correctIndexPath.row)
    }
    
    private func deleteShortcutInTable(indexPath: IndexPath) {
        let correctIndexPath = adjustShortcutIndexPath(indexPath: indexPath)
        tableSections[2].tableCells.remove(at: correctIndexPath.row)
    }
    
    private func updateShortcutViewModel(indexPath: IndexPath) {
        let correctIndexPath = adjustShortcutIndexPath(indexPath: indexPath)
        
        if let shortcutViewModel = tableSections[2].tableCells[correctIndexPath.row] as? MenuItemViewModelShortcutType {
            shortcutViewModel.reuse(for: dataSource.shortcuts[indexPath.row])
        }
    }
}

extension MenuViewModel: ShortcutListDataSourceObserver {
    func shortcutWillChange() {
        shortcutTableView?.tableViewBeginUpdates()
    }
    
    func shortcutDidChange() {
        shortcutTableView?.tableViewEndUpdates()
    }
    
    func shortcutInserted(at newIndexPath: IndexPath) {
        addShortcutInTable(indexPath: newIndexPath)
        shortcutTableView?.tableViewInsertRow(at: adjustShortcutIndexPath(indexPath: newIndexPath))
    }
    
    func shortcutDeleted(at indexPath: IndexPath) {
        deleteShortcutInTable(indexPath: indexPath)
        shortcutTableView?.tableViewDeleteRow(at: adjustShortcutIndexPath(indexPath: indexPath))
    }
    
    func shortcutUpdated(at indexPath: IndexPath) {
        updateShortcutViewModel(indexPath: indexPath)
        shortcutTableView?.tableViewUpdateRow(at: adjustShortcutIndexPath(indexPath: indexPath))
    }
}
