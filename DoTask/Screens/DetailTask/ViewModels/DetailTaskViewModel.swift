//
//  DetailTaskViewModel.swift
//  DoTask
//
//  Created by kluv on 21/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import Foundation

class DetailTaskViewModel: DetailTaskViewModelType, DetailTaskViewModelInputs, DetailTaskViewModelOutputs {
    
    private var task: Task
    private var dataSource: TaskListDataSource
    
    private var onCalendarSelect: ((Date?, CalendarPickerViewOutputs) -> Void)?
    private var onTimeReminderSelect: ((Date, TimePickerViewOutputs) -> Void)?
    private var onShortcutSelect: ((String?, ShortcutListViewOutputs) -> Void)?
    
    private var taskDateInfoCell: DetailTaskTableItemViewModelType?
    private var taskReminderInfoCell: DetailTaskTableItemViewModelType?
        
    private let subtaskSectionIndex: Int = 0
    
    var inputs: DetailTaskViewModelInputs { return self }
    var outputs: DetailTaskViewModelOutputs { return self }
    
    init(taskUID: String?, shortcutUID: String?, taskDate: Date?, dataSource: TaskListDataSource) {
                
        self.task = dataSource.taskModelByIdentifier(identifier: taskUID) ?? Task()
        
        if self.task.isNew {
            self.task.taskDate = taskDate
        }
        
        self.dataSource = dataSource
        
        self.selectedDate = Observable(task.taskDate)
        self.selectedTime = Observable(task.reminderDate ? task.taskDate : nil)
        
        if let shortcut =  self.task.shortcut {
            self.selectedShortcut = Observable(ShortcutData(title: shortcut.name, colorHex: shortcut.color))
        } else {
            self.selectedShortcut = Observable(ShortcutData(title: nil, colorHex: nil))
        }

        self.importanceLevel = Int(task.importanceLevel)
        self.asksToDelete = Observable(false)
        
        setShortcut(shortcutUID: shortcutUID)
        setupSections()
    }
    
    
    // MARK: INPUTS
    
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
            task.taskDate = date
            setReminder(date: nil)
        }
        selectedDate.value = date
        
        if let taskDateViewModel = taskDateInfoCell as? TaskDateViewModelType {
            taskDateViewModel.inputs.setDate(date: date)
        }
    }
    
    func setReminder(date: Date?) {
        if let date = date {
            task.reminderDate = true
            task.taskDate = date
        } else {
            task.reminderDate = false
        }
        selectedTime.value = date
        
        if let taskReminderViewModel = taskReminderInfoCell as? TaskReminderViewModelType {
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
        } else {
            dataSource.updateTask(from: task)
        }
    }
    
    func deleteTask() {
        dataSource.deleteTask(from: task)
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
        var normalizeTimeFromDate = selectedDate.value ?? Date()
        if let taskTime = selectedTime.value {
            normalizeTimeFromDate = taskTime
            let calendar = Calendar.current.taskCalendar
            let timeComponents = calendar.dateComponents([.hour, .minute], from: normalizeTimeFromDate)
            
            if let hour = timeComponents.hour, let minute = timeComponents.minute {
                guard let dateWithTime = Calendar.current.taskCalendar.date(bySettingHour: hour, minute: minute, second: 0, of: normalizeTimeFromDate) else { return }
                normalizeTimeFromDate = dateWithTime
            }
        } else if !normalizeTimeFromDate.isDayToday() {
            guard let dateWithTime = Calendar.current.taskCalendar.date(bySettingHour: 8, minute: 00, second: 0, of: normalizeTimeFromDate) else { return }
            normalizeTimeFromDate = dateWithTime
        }
        
        if let reminderAction = onTimeReminderSelect {
            reminderAction(normalizeTimeFromDate, self)
        }
    }
    
    func openShortcuts() {
        if let shortcutAction = onShortcutSelect {
            shortcutAction(shortcutUID, self)
        }
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
}

// MARK: Setup Sections

extension DetailTaskViewModel {
    private func setupSections() {
        
        let subtasks = self.task.subtasks.map {
            return SubtaskViewModel(subtask: $0)
        }
                
        let subtasksSection = DetailTaskTableSectionViewModel(cells: subtasks, sectionHeight: 0)
        
        tableSections.append(subtasksSection)
        
        if !isNewTask {
            taskDateInfoCell = TaskDateViewModel(taskDate: task.taskDate) { [weak self] in
                guard let strongSelf = self else { return }
                if !strongSelf.isDone {
                    self?.openCalendar()
                }
            }
            
            taskReminderInfoCell = TaskReminderViewModel(taskTime: task.reminderDate ? task.taskDate : nil) { [weak self] in
                guard let strongSelf = self else { return }
                if !strongSelf.isDone {
                    self?.openReminder()
                }
            }
            
            let deleteCell = TaskDeleteViewModel { [weak self] in
                self?.asksToDelete.value = true
            }
                        
            guard let taskDateInfoCell = taskDateInfoCell, let taskReminderInfoCell = taskReminderInfoCell else { return }
            
            let infoSection = DetailTaskTableSectionViewModel(cells: [taskDateInfoCell, taskReminderInfoCell, deleteCell], sectionHeight: StyleGuide.DetailTask.Sizes.infoSectionHeaderHeight)
            tableSections.append(infoSection)
        }
        
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
