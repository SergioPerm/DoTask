//
//  DetailShortcutViewModel.swift
//  DoTask
//
//  Created by KLuV on 05.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol DetailShortcutViewModelInputs {
    func setShortcutUID(UID: String?)
    func setColor(colorHex: String)
    func setTitle(title: String)
    func toggleshowInMainListSetting()
    func save()
    func delete()
    func updateTasksCounter()
    func setOpenMainTaskListHandler(handler: (() -> ())?)
    func setDefaultColor()
}

protocol DetailShortcutViewModelOutputs {
    var selectedColor: Observable<String> { get }
    var countOfTasksEvent: Event<String> { get }
    var title: String { get }
    var isNew: Bool { get }
    var showInMainListSetting: Bool { get }
    func getAllColors() -> [ColorSelectionItemViewModelType]
}

protocol DetailShortcutViewModelType {
    var inputs: DetailShortcutViewModelInputs { get }
    var outputs: DetailShortcutViewModelOutputs { get }
}

class DetailShortcutViewModel: DetailShortcutViewModelType, DetailShortcutViewModelInputs, DetailShortcutViewModelOutputs {
    
    private var shortcut: Shortcut
    private var dataSource: ShortcutListDataSource
    private var tasksDataSource: TaskListDataSourceCoreData
    private let settingsService: SettingService

    private var openMainTasksHandler: (() -> ())?
    
    private var shortcutUID: String? {
        didSet {
            if let shortcutUID = shortcutUID {
                self.shortcut = dataSource.shortcutByIdentifier(identifier: shortcutUID) ?? Shortcut()
                
                if self.shortcut.isNew {
                    self.shortcut.color = presetColors[2]
                }
                
                self.selectedColor = Observable(shortcut.color)
                self.title = shortcut.name
            }
        }
    }

    private var presetColors: [String] = [
        R.color.shortcutDetail.colorSelection.red()!.toHexString(),
        R.color.shortcutDetail.colorSelection.pink()!.toHexString(),
        R.color.shortcutDetail.colorSelection.lightPink()!.toHexString(),
        R.color.shortcutDetail.colorSelection.lightOrange()!.toHexString(),
        R.color.shortcutDetail.colorSelection.darkOrange()!.toHexString(),
        R.color.shortcutDetail.colorSelection.orange()!.toHexString(),
        R.color.shortcutDetail.colorSelection.green2()!.toHexString(),
        R.color.shortcutDetail.colorSelection.darkYellow()!.toHexString(),
        R.color.shortcutDetail.colorSelection.darkGreen()!.toHexString(),
        R.color.shortcutDetail.colorSelection.green()!.toHexString(),
        R.color.shortcutDetail.colorSelection.lightGreen()!.toHexString(),
        R.color.shortcutDetail.colorSelection.lightBlue()!.toHexString(),
        R.color.shortcutDetail.colorSelection.blue()!.toHexString(),
        R.color.shortcutDetail.colorSelection.blue2()!.toHexString(),
        R.color.shortcutDetail.colorSelection.darkBlue()!.toHexString(),
        R.color.shortcutDetail.colorSelection.darkPurple()!.toHexString(),
        R.color.shortcutDetail.colorSelection.purple()!.toHexString(),
        R.color.shortcutDetail.colorSelection.lightPurple()!.toHexString(),
        R.color.shortcutDetail.colorSelection.lilac()!.toHexString(),
        R.color.shortcutDetail.colorSelection.brown()!.toHexString(),
        R.color.shortcutDetail.colorSelection.black()!.toHexString()
    ]
    
    var inputs: DetailShortcutViewModelInputs { return self }
    var outputs: DetailShortcutViewModelOutputs { return self }

    init(dataSource: ShortcutListDataSource, tasksDataSource: TaskListDataSourceCoreData, settingsService: SettingService) {
        self.shortcut = Shortcut()
        self.dataSource = dataSource
        self.tasksDataSource = tasksDataSource
        self.settingsService = settingsService
        self.selectedColor = Observable(shortcut.color)
        self.countOfTasksEvent = Event<String>()
    }
        
    // MARK: Inputs
    
    func setDefaultColor() {
        if isNew {
            setColor(colorHex: presetColors[0])
        }
    }
    
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
            if let openMainTasksListAction = openMainTasksHandler {
                openMainTasksListAction()
            }
            dataSource.deleteShortcut(for: shortcut)
        }
    }

    func setShortcutUID(UID: String?) {
        self.shortcutUID = UID
    }
    
    func updateTasksCounter() {
        guard let shortcutUID = shortcutUID else { return }
        tasksDataSource.applyFilters(filter: TaskListFilter(shortcutFilter: shortcutUID, dayFilter: nil))
        let tasksCount = tasksDataSource.tasks.count
        countOfTasksEvent.raise(R.string.localizable.shortcutDetailTaskCount(detailShortcutTaskCount: tasksCount, preferredLanguages: [settingsService.getSettings().language.rawValue]))
    }
    
    func setOpenMainTaskListHandler(handler: (() -> ())?) {
        openMainTasksHandler = handler
    }
    
    // MARK: OUTPUTS
    
    var selectedColor: Observable<String>
    var title: String = ""
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
    
    var countOfTasksEvent: Event<String>
}
