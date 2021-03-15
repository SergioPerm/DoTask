//
//  MenuShortcutViewModel.swift
//  DoTask
//
//  Created by KLuV on 07.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

class MenuViewModel: MenuViewModelType, MenuViewModelInputs, MenuViewModelOutputs {
    
    private var dataSource: ShortcutListDataSource

    private let createShortcutViewModel: CreateShortcutMenuItemViewModel = CreateShortcutMenuItemViewModel()
    private var selectedViewModel: MenuItemViewModelSelectableType?
    
    private var shortcutsSectionIndex: Int = 3
    
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
    
    func selectItem(for indexPath: IndexPath) {
        if let shortcutViewModel = tableSections[indexPath.section].tableCells[indexPath.row] as? MenuItemViewModelSelectableType {
            selectedViewModel?.selectedItem.value = false
            selectedViewModel = shortcutViewModel
            selectedViewModel?.selectedItem.value = true
        }
    }
    
    // MARK: Outputs
        
    var tableSections: [MenuItemSectionViewModelType]
    
}

extension MenuViewModel {
    private func setupSections() {
        let settingsSection = MenuItemSectionViewModel(cells: [SettingsMenuItemViewModel()], sectionHeight: Double.leastNormalMagnitude)

        let selectedCellViewModel = MainMenuItemViewModel(title: "Task list", imageName: "colorFlat", selected: true, menuType: .mainList)
        selectedViewModel = selectedCellViewModel
                
        let mainItemsSection = MenuItemSectionViewModel(cells: [
            selectedCellViewModel,
            DiaryMenuItemViewModel(title: "Task diary", imageName: "diary", menuType: .diaryList)
        ], sectionHeight: 30)
        
        let createShortcutSection = MenuItemSectionViewModel(cells: [createShortcutViewModel], sectionHeight: 0)
        
        let shortcutSection = MenuItemSectionViewModel(cells: [], sectionHeight: 0)
        dataSource.shortcuts.forEach {
            shortcutSection.tableCells.append(ShortcutMenuItemViewModel(shortcut: $0))
        }
        
        tableSections.append(settingsSection)
        tableSections.append(mainItemsSection)
        tableSections.append(createShortcutSection)
        tableSections.append(shortcutSection)
    }
            
    private func addShortcutInTable(indexPath: IndexPath) {
        tableSections[shortcutsSectionIndex].tableCells.insert(ShortcutMenuItemViewModel(shortcut: dataSource.shortcuts[indexPath.row]), at: indexPath.row)
    }
    
    private func deleteShortcutInTable(indexPath: IndexPath) {
        tableSections[shortcutsSectionIndex].tableCells.remove(at: indexPath.row)
    }
    
    private func updateShortcutViewModel(indexPath: IndexPath) {
        if let shortcutViewModel = tableSections[shortcutsSectionIndex].tableCells[indexPath.row] as? MenuItemViewModelShortcutType {
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
        shortcutTableView?.tableViewInsertRow(at: IndexPath(row: newIndexPath.row, section: shortcutsSectionIndex))
    }
    
    func shortcutDeleted(at indexPath: IndexPath) {
        deleteShortcutInTable(indexPath: indexPath)
        shortcutTableView?.tableViewDeleteRow(at: IndexPath(row: indexPath.row, section: shortcutsSectionIndex))
    }
    
    func shortcutUpdated(at indexPath: IndexPath) {
        updateShortcutViewModel(indexPath: indexPath)
        shortcutTableView?.tableViewUpdateRow(at: IndexPath(row: indexPath.row, section: shortcutsSectionIndex))
    }
}
