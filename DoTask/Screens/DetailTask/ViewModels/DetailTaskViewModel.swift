//
//  DetailTaskViewModel.swift
//  DoTask
//
//  Created by kluv on 21/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import Foundation

protocol DetailTaskViewModelInputs: AnyObject {
    func setTaskDate(date: Date?)
    func setReminder(date: Date?)
    func setTitle(title: String)
    func setShortcut(shortcutUID: String?)
    func increaseImportance()
    func addSubtask() -> IndexPath
    func deleteSubtask(indexPath: IndexPath)
    func moveSubtask(from: Int, to: Int)
    func saveTask()
    func deleteTask()
    func askForDelete()
    
    func setCalendarHandler(onCalendarSelect: ((_ selectedDate: Date?, _ vc: CalendarPickerViewOutputs) -> Void)?)
    func setReminderHandler(onTimeReminderSelect: ((_ selectedTime: Date, _ vc: TimePickerViewOutputs) -> Void)?)
    func setShortcutHandler(onShortcutSelect: ((String?, ShortcutListViewOutputs) -> Void)?)
    
    func setNotifyPermissionDontAllowHandler(handler: (() -> ())?)
    
    func openCalendar()
    func openReminder()
    func openShortcuts()
    
    func setTaskUID(UID: String?)
    func setFilter(filter: TaskListFilter)
}

protocol DetailTaskViewModelOutputs {
    var selectedDate: Observable<Date?> { get }
    var selectedTime: Observable<Date?> { get }
    var selectedShortcut: Observable<ShortcutData> { get }
    var shortcutUID: String? { get }
    var isNewTask: Bool { get }
    var isDone: Bool { get }
    var importanceLevel: Int { get }
    var title: String { get }
    var tableSections: [DetailTaskTableSectionViewModelType] { get }
    var onReturnToEdit: Observable<Bool> { get }
    var asksToDelete: Observable<Bool> { get }
    
    var addSubtaskEvent: Event<Bool> { get }
}

protocol DetailTaskViewModelType: AnyObject {
    var inputs: DetailTaskViewModelInputs { get }
    var outputs: DetailTaskViewModelOutputs { get }
}

class DetailTaskViewModel: DetailTaskViewModelType, DetailTaskViewModelInputs, DetailTaskViewModelOutputs {
    
    private var task: Task
    private let dataSource: TaskListDataSource
    private let spotlightService: SpotlightTasksService
    
    private var onCalendarSelect: ((Date?, CalendarPickerViewOutputs) -> Void)?
    private var onTimeReminderSelect: ((Date, TimePickerViewOutputs) -> Void)?
    private var onShortcutSelect: ((String?, ShortcutListViewOutputs) -> Void)?
    
    private var onDoNotAllowNotify: (()->())?
    
    private var taskDateInfoViewModel: DetailTaskTableItemViewModelType?
    private var taskReminderInfoViewModel: DetailTaskTableItemViewModelType?
        
    private let subtaskSectionIndex: Int = 0
    
    private var filter: TaskListFilter?
    
    private let settingsService: SettingService = AppDI.resolve()
    private var currentSettings: SettingService.Settings
    
    var inputs: DetailTaskViewModelInputs { return self }
    var outputs: DetailTaskViewModelOutputs { return self }
    
    init(dataSource: TaskListDataSource, spotlightService: SpotlightTasksService) {
        self.task = Task()
                
        self.dataSource = dataSource
        self.spotlightService = spotlightService
        
        self.selectedDate = Observable(task.taskDate)
        self.selectedTime = Observable(task.reminderDate ? task.taskDate : nil)
        
        self.selectedShortcut = Observable(ShortcutData(title: nil, colorHex: nil))
        
        self.importanceLevel = Int(task.importanceLevel)
        self.asksToDelete = Observable(false)
        self.addSubtaskEvent = Event<Bool>()
        
        //data from settings
        currentSettings = settingsService.getSettings()
        
        if task.isNew {
            if let defaultShortcut = currentSettings.task.defaultShortcut {
                setShortcut(shortcutUID: defaultShortcut)
            } else if let lastUsedShortcut = currentSettings.lastUsedShortcut {
                setShortcut(shortcutUID: lastUsedShortcut)
            }
        }
    }
    
    // MARK: INPUTS
    
    func setTaskUID(UID: String?) {
        guard let taskUID = UID, let taskFromUID = dataSource.taskModelByIdentifier(identifier: taskUID) else { return }
        
        task = taskFromUID
                
        selectedDate = Observable(task.taskDate)
        selectedTime = Observable(task.reminderDate ? task.taskDate : nil)
        
        if let shortcut = task.shortcut {
            selectedShortcut = Observable(ShortcutData(title: shortcut.name, colorHex: shortcut.color))
        } else {
            selectedShortcut = Observable(ShortcutData(title: nil, colorHex: nil))
        }
        
        importanceLevel = Int(task.importanceLevel)
    }
    
    func setFilter(filter: TaskListFilter) {
        if task.isNew {
            task.taskDate = filter.dayFilter?.startOfDay()// ?? Date().startOfDay()
            selectedDate = Observable(task.taskDate)
        }
        
        if let _ = filter.dayFilter {
            selectedDate = Observable(task.taskDate)
            selectedTime = Observable(task.reminderDate ? task.taskDate : nil)
        }
    
        setShortcut(shortcutUID: filter.shortcutFilter)
        setupSections()
    }
    
    func setCalendarHandler(onCalendarSelect: ((Date?, CalendarPickerViewOutputs) -> Void)?) {
        self.onCalendarSelect = onCalendarSelect
    }
    
    func setReminderHandler(onTimeReminderSelect: ((Date, TimePickerViewOutputs) -> Void)?) {
        self.onTimeReminderSelect = onTimeReminderSelect
    }
    
    func setShortcutHandler(onShortcutSelect: ((String?, ShortcutListViewOutputs) -> Void)?) {
        self.onShortcutSelect = onShortcutSelect
    }
    
    func setTaskDate(date: Date?) {
        
        if task.reminderDate, let taskDate = task.taskDate, let newDate = date {
            //set time for selected date
            let hour = Calendar.current.taskCalendar.component(.hour, from: taskDate)
            let minute = Calendar.current.taskCalendar.component(.minute, from: taskDate)
            task.taskDate = Calendar.current.taskCalendar.date(bySettingHour: hour, minute: minute, second: 0, of: newDate)
        } else {
            setReminder(date: nil)
                        
            task.taskDate = date
        }
        selectedDate.value = date
        
        if let taskDateViewModel = taskDateInfoViewModel as? TaskDateViewModelType {
            taskDateViewModel.inputs.setDate(date: date)
        }
    }
    
    func setReminder(date: Date?) {
        if let date = date {
            task.reminderDate = true
            
            //return current task date when is empty
            task.taskDate = date
            selectedDate.value = date
            
            if let taskDateViewModel = taskDateInfoViewModel as? TaskDateViewModelType {
                taskDateViewModel.inputs.setDate(date: date)
            }
        } else {
            task.reminderDate = false
        }
        selectedTime.value = date
        
        if let taskReminderViewModel = taskReminderInfoViewModel as? TaskReminderViewModelType {
            taskReminderViewModel.inputs.setTime(time: date)
        }
    }
    
    func setTitle(title: String) {
        task.title = title
    }
    
    func increaseImportance() {
        task.importanceLevel += 1
        importanceLevel = Int(task.importanceLevel)
    }
  
    func addSubtask() -> IndexPath {
        tableSections[subtaskSectionIndex].tableCells.append(SubtaskViewModel(subtask: Subtask()))
        return IndexPath(row: tableSections[subtaskSectionIndex].tableCells.count - 1, section: subtaskSectionIndex)
    }
    
    func deleteSubtask(indexPath: IndexPath) {
        tableSections[subtaskSectionIndex].tableCells.remove(at: indexPath.row)
    }
        
    func moveSubtask(from: Int, to: Int) {
        tableSections[subtaskSectionIndex].tableCells.insert(tableSections[subtaskSectionIndex].tableCells.remove(at: from), at: to)
    }
    
    func saveTask() {
        var priority: Int16 = 0
        task.subtasks = tableSections[subtaskSectionIndex].tableCells.compactMap {
            if let subtaskViewModel = $0 as? SubtaskViewModelType {
                var subtask = Subtask()
                subtask.isDone = subtaskViewModel.outputs.isDone
                subtask.title = subtaskViewModel.outputs.title
                subtask.priority = priority
                
                priority += 1
                
                return subtask
            }
            return nil
        }
        
        if task.isNew {
            dataSource.addTask(from: task)
            spotlightService.addTask(task: task)
        } else {
            dataSource.updateTask(from: task)
            spotlightService.updateTask(task: task)
        }
        
        if let shortcut = task.shortcut, shortcut.showInMainList {
            currentSettings.lastUsedShortcut = task.shortcut?.uid
            settingsService.saveSettings(settings: currentSettings)
        }
    }
    
    func deleteTask() {
        dataSource.deleteTask(from: task)
        spotlightService.deleteTask(task: task)
    }
    
    func askForDelete() {
        asksToDelete.value = true
    }
    
    func setShortcut(shortcutUID: String?) {
        guard let shortcutUID = shortcutUID else { return }
        
        if let shortcut = dataSource.shortcutModelByIdentifier(identifier: shortcutUID) {
            task.shortcut = shortcut
            selectedShortcut.value = ShortcutData(title: shortcut.name, colorHex: shortcut.color)
        }
    }
    
    func openCalendar() {
        if let calendarAction = self.onCalendarSelect {
            calendarAction(self.selectedDate.value, self)
        }
    }
    
    func openReminder() {
        
        // check permissions
        
        let pushNotificationService: PushNotificationService = AppDI.resolve()
        pushNotificationService.checkAuthorization { [weak self] didAllow in
            guard let strongSelf = self else { return }
            if didAllow {
                if let reminderAction = strongSelf.onTimeReminderSelect {
                    reminderAction(strongSelf.normalizeTimeForReminder(), strongSelf)
                }
            } else {
                if let onDoNotAllowNotify = strongSelf.onDoNotAllowNotify {
                    onDoNotAllowNotify()
                }
            }
        }
                
    }
    
    func openShortcuts() {
        if let shortcutAction = onShortcutSelect {
            shortcutAction(shortcutUID, self)
        }
    }
    
    func setNotifyPermissionDontAllowHandler(handler: (() -> ())?) {
        onDoNotAllowNotify = handler
    }
    
    // MARK: OUTPUTS
    
    var selectedDate: Observable<Date?>
    var selectedTime: Observable<Date?>
    var importanceLevel: Int
    
    var title: String {
        return task.title
    }
    
    var selectedShortcut: Observable<ShortcutData>
    
    var isNewTask: Bool {
        return task.isNew
    }
    
    var isDone: Bool {
        return task.isDone
    }
    
    var shortcutUID: String? {
        if let shortcut = task.shortcut {
            return shortcut.uid
        }
        
        return nil
    }
    
    var tableSections: [DetailTaskTableSectionViewModelType] = []
    
    var onReturnToEdit: Observable<Bool> = Observable(true)
    
    var asksToDelete: Observable<Bool>
    
    var addSubtaskEvent: Event<Bool>
}

// MARK: Methods

private extension DetailTaskViewModel {
    func normalizeTimeForReminder() -> Date {
        var normalizeTimeFromDate = selectedDate.value ?? Date()
        if let taskTime = selectedTime.value {
            normalizeTimeFromDate = taskTime
            let calendar = Calendar.current.taskCalendar
            let timeComponents = calendar.dateComponents([.hour, .minute], from: normalizeTimeFromDate)
            
            if let hour = timeComponents.hour, let minute = timeComponents.minute {
                guard let dateWithTime = Calendar.current.taskCalendar.date(bySettingHour: hour, minute: minute, second: 0, of: normalizeTimeFromDate) else { return Date() }
                normalizeTimeFromDate = dateWithTime
            }
        } else if !normalizeTimeFromDate.isDayToday() {
            guard let dateWithTime = Calendar.current.taskCalendar.date(bySettingHour: 8, minute: 00, second: 0, of: normalizeTimeFromDate) else { return Date() }
            normalizeTimeFromDate = dateWithTime
        } else {
            normalizeTimeFromDate = Date()
        }
        
        return normalizeTimeFromDate
    }
}

// MARK: Setup Sections

extension DetailTaskViewModel {
    private func setupSections() {
        
        let subtasks = self.task.subtasks.map {
            return SubtaskViewModel(subtask: $0)
        }
                
        let subtasksSection = DetailTaskTableSectionViewModel(cells: subtasks, sectionHeight: 0)
        
        tableSections.append(subtasksSection)
        
        var cells: [DetailTaskTableItemViewModelType] = []
        
        let addSubtaskCell = AddSubtaskViewModel { [weak self] in
            self?.addSubtaskEvent.raise(true)
        }
        
        cells.append(addSubtaskCell)
        
        if !isNewTask {
            taskDateInfoViewModel = TaskDateViewModel(taskDate: task.taskDate) { [weak self] in
                guard let strongSelf = self else { return }
                if !strongSelf.isDone {
                    self?.openCalendar()
                }
            }
            
            taskReminderInfoViewModel = TaskReminderViewModel(taskTime: task.reminderDate ? task.taskDate : nil) { [weak self] in
                guard let strongSelf = self else { return }
                if !strongSelf.isDone {
                    self?.openReminder()
                }
            }
            
            let deleteCell = TaskDeleteViewModel { [weak self] in
                self?.asksToDelete.value = true
            }
                                    
            guard let taskDateInfoCell = taskDateInfoViewModel, let taskReminderInfoCell = taskReminderInfoViewModel else { return }
            
            cells.append(contentsOf: [taskDateInfoCell, taskReminderInfoCell, deleteCell])
        }
        
        let infoSection = DetailTaskTableSectionViewModel(cells: cells, sectionHeight: StyleGuide.DetailTask.Sizes.infoSectionHeaderHeight)
        tableSections.append(infoSection)        
    }
}

// MARK: CalendarPickerViewOutputs
extension DetailTaskViewModel: CalendarPickerViewOutputs {
    var selectedCalendarDate: Date? {
        get {
            return selectedDate.value
        }
        
        set {
            setTaskDate(date: newValue)
        }
    }
    
    func comletionAfterCloseCalendar() {
        if task.isNew {
            onReturnToEdit.value = true
        }
    }
}

// MARK: TimePickerViewOutputs
extension DetailTaskViewModel: TimePickerViewOutputs {
    var selectedReminderTime: Date? {
        get {
            return selectedTime.value
        }
        set {
            setReminder(date: newValue)
        }
    }

    func completionAfterCloseTimePicker() {
        if task.isNew {
            onReturnToEdit.value = true
        }
    }
}

// MARK: ShortcutListViewOutputs
extension DetailTaskViewModel: ShortcutListViewOutputs {
    var selectedShortcutUID: String? {
        get {
            return shortcutUID
        }
        set {
            setShortcut(shortcutUID: newValue)
        }
    }
}
