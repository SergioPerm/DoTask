//
//  TaskListViewModel.swift
//  DoTask
//
//  Created by KLuV on 27.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

struct TaskListFilter {
    let shortcutFilter: String?
    var dayFilter: Date?
}

enum TaskListMode {
    case calendar
    case list
}

class TaskListViewModel: TaskListViewModelType, TaskListViewModelInputs, TaskListViewModelOutputs {
    
    private var dataSource: TaskListDataSource
            
    weak var view: TaskListViewObservable?
    
    var inputs: TaskListViewModelInputs { return self }
    var outputs: TaskListViewModelOutputs { return self }
    
    private var tableViewFRCHelper: TableViewFRCHelper = TableViewFRCHelper()
    private var calendarDate: Date?
    private var currentFilter: TaskListFilter?
        
    //data for FRC state without empty values, in OUTPUTS -> periodItems store all section including empty values
    private var periodItemsFRC: [TaskListPeriodItemViewModelType] = []
    
    init(dataSource: TaskListDataSource) {
        self.dataSource = dataSource
        self.shortcutFilter = Observable(nil)
        self.taskDiaryMode = Observable(false)
        self.periodItems = []
        self.taskListMode = Observable(TaskListMode.list)
        self.calendarMonth = Observable(Date())
        
        self.dataSource.observer = self
        		
        tableViewFRCHelper.delegate = self
        
        //dataSource.clearData()
        
        setupCalendarViewModel()
                
        loadData()
        let pushNotificationService: PushNotificationService = AppDI.resolve()
        pushNotificationService.attachObserver(self)
    }
    
    // MARK: Inputs
            
    func setFilter(filter: TaskListFilter) {
        currentFilter = filter
        
        if taskListMode.value == .calendar {
            currentFilter?.dayFilter = calendarSelectedDate
        }
        
        //unwrap
        guard let currentFilter = currentFilter else { return }
        
        dataSource.applyFilters(filter: currentFilter)
        
        //and load data
        loadData()
        
        //send to view
        if let shortcutUID = currentFilter.shortcutFilter {
            let shortcut = dataSource.shortcutModelByIdentifier(identifier: shortcutUID)
            shortcutFilter.value = (title: shortcut?.name, colorHex: shortcut?.color)
        } else {
            if shortcutFilter.value != nil {
                shortcutFilter.value = nil
            }
        }
    }
    
    func editTask(indexPath: IndexPath) {
        if let itemViewModel = periodItems[indexPath.section].outputs.tasks[indexPath.row] as? TaskListItemViewModelType {
            let taskUID = itemViewModel.outputs.getTaskUID()
            view?.editTask(taskUID: taskUID)
        }
    }
    
    func setMode(mode: TaskListMode) {
        
        taskListMode.value = mode
        
        if mode == .calendar {
            calendarDate = Date().startOfDay()
        } else {
            calendarDate = nil
        }
        
        var filter = currentFilter ?? TaskListFilter(shortcutFilter: nil, dayFilter: nil)
        filter.dayFilter = calendarDate
        
        setFilter(filter: filter)
                
        periodItems.forEach {
            $0.inputs.setTaskListMode(mode: mode)
        }
    
    }
    
    // MARK: Outputs
    
    var periodItems: [TaskListPeriodItemViewModelType]
    var shortcutFilter: Observable<ShortcutData?>
    var taskDiaryMode: Observable<Bool>
    var taskListMode: Observable<TaskListMode>
    var calendarViewModel: CalendarViewModelType?
    
    var calendarSelectedDate: Date? {
        return calendarViewModel?.outputs.selectedDay?.outputs.date
    }
    
    var calendarMonth: Observable<Date>
    
}

extension TaskListViewModel {
    
    private func setupCalendarViewModel() {
        let firstTaskDate = dataSource.getFirstTaskDate() ?? Date()
        let calendarVM = CalendarViewModel(startDate: firstTaskDate)
        calendarVM.selectedDateHandler = setCalendarDate(date:)
        calendarVM.setCalendarMonthHandler = setCalendarMonth(date:)
        
        calendarViewModel = calendarVM
    }
    
    private func changeDoneTask(taskUID: String, done: Bool) {
        if done {
            dataSource.setDoneForTask(with: taskUID)
        } else {
            dataSource.unsetDoneForTask(with: taskUID)
        }
    }
    
    private func setCalendarDate(date: Date) {
        var filter = currentFilter ?? TaskListFilter(shortcutFilter: nil, dayFilter: nil)
        filter.dayFilter = date
        
        setFilter(filter: filter)
        
        view?.tableViewReload()
        
        periodItems.forEach {
            $0.inputs.setTaskListMode(mode: .calendar)
        }
    }
    
    private func setCalendarMonth(date: Date) {
        calendarMonth.value = date
    }
    
    private func loadData() {
        
        recreatePeriodItemsWireframe()
        periodItemsFRC.removeAll()
        
        dataSource.tasksWithSections.forEach { timePeriod in
            
            guard let periodItem = periodItems.first(where: {
                $0.outputs.dailyName == timePeriod.dailyName
            }) else {
                return
            }
                        
            timePeriod.tasks.forEach { task in
                periodItem.inputs.insert(task: TaskListItemViewModel(task: task, setDoneTaskHandler: changeDoneTask(taskUID:done:)))
                
            }
            
            periodItemsFRC.append(periodItem)

        }
        
        updateCounter()
        
        if taskListMode.value == .calendar {
            updateTasksInfoInCalendar()
        }
    }
     
    private func updateCounter() {
        guard let periodItem = periodItems.first(where: {
            $0.outputs.dailyName?.haveDoneCounter() == true
        }) else {
            return
        }
        
        if let dailyName = periodItem.outputs.dailyName {
            if let counter = dataSource.getDoneCounterForPeriod(dailyPeriod: dailyName, taskListFilter: nil) {
                periodItem.inputs.setDoneCounter(counter: counter)
            }
        }
    }
    
    private func recreatePeriodItemsWireframe() {
        periodItems.removeAll()
        
        if taskListMode.value == .list {
            DailyName.allCases.forEach({
                var taskTimePeriod = TaskTimePeriod()
                taskTimePeriod.dailyName = $0
                taskTimePeriod.name = $0.localized()
                
                let periodItem = TaskListPeriodItemViewModel(taskTimePeriod: taskTimePeriod, taskListMode: taskListMode.value)
                
                if $0 == DailyName.today {
                    periodItem.inputs.setShowingCapWhenTasksIsEmpty(emptyState: true, capMode: .MainCap)
                } else {
                    periodItem.inputs.setShowingCapWhenTasksIsEmpty(emptyState: true, capMode: .LittleSpaceCap)
                }
                
                periodItems.append(periodItem)
            })
        } else {
            let filter = currentFilter ?? TaskListFilter(shortcutFilter: nil, dayFilter: nil)
            
            if let dayFilter = filter.dayFilter {
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = TimeZone.autoupdatingCurrent
                dateFormatter.dateFormat = "dd MMMM"
                 
                var taskTimePeriod = TaskTimePeriod()
                taskTimePeriod.name = dateFormatter.string(from: dayFilter)
                taskTimePeriod.date = dayFilter
                
                let periodItem = TaskListPeriodItemViewModel(taskTimePeriod: taskTimePeriod, taskListMode: taskListMode.value)
                
                periodItem.inputs.setShowingCapWhenTasksIsEmpty(emptyState: true, capMode: .CalendarCap)
                
                periodItems.append(periodItem)
            }
        }
    }
            
    private func updateTaskInData(at indexPath: IndexPath) {
        if let itemViewModel = periodItemsFRC[indexPath.section].outputs.tasks[indexPath.row] as? TaskListItemViewModelType {
            let task = dataSource.tasksWithSections[indexPath.section].tasks[indexPath.row]
            itemViewModel.inputs.reuse(task: task)

            if taskListMode.value == .calendar {
                updateTasksInfoInCalendar()
            }
        }
    }
    
    private func updateTasksInfoInCalendar() {
        let availabilityTasksByDate = dataSource.getTasksByDate()
        
        calendarViewModel?.inputs.updateTasksInDays(availabilityTasksByDate: availabilityTasksByDate)
    }
    
    private func isTodaySection(section: Int) -> Bool {
        let taskData = dataSource.tasksWithSections[section]
        
        if taskData.name == DailyName.today.rawValue {
            return true
        }
        
        return false
    }
}

extension TaskListViewModel: TableViewFRCHelperDelegate {
    
    func addItem(indexPath: IndexPath) {
        
        let sectionData = dataSource.tasksWithSections[indexPath.section]
        let task = sectionData.tasks[indexPath.row]
        
        let taskViewModel = TaskListItemViewModel(task: task, setDoneTaskHandler: changeDoneTask(taskUID:done:))
        
        let periodItem = periodItems.first(where: {
            $0.outputs.dailyName == sectionData.dailyName
        })
        
        let sectionIndex = periodItems.firstIndex(where: {
            $0.outputs.dailyName == periodItem?.outputs.dailyName
        })
        
        if let periodItem = periodItem, let sectionIndex = sectionIndex {
            //delete cap
            if periodItem.outputs.isEmpty && periodItem.outputs.showingCapWhenTasksIsEmpty {
                view?.tableViewDeleteRow(at: IndexPath(row: 0, section: sectionIndex))
            }
            
            periodItem.inputs.insert(task: taskViewModel, at: indexPath.row)
            
            view?.tableViewInsertRow(at: IndexPath(row: indexPath.row, section: sectionIndex))
        }
                        
        if taskListMode.value == .calendar {
            updateTasksInfoInCalendar()
        }
    }
    
    func deleteItem(indexPath: IndexPath) {
        let periodItemFRC = periodItemsFRC[indexPath.section]
        periodItemFRC.inputs.remove(at: indexPath.row)
        
        if taskListMode.value == .calendar {
            updateTasksInfoInCalendar()
        }
        
        //update tableView
        let sectionIndex = periodItems.firstIndex(where: {
            $0.outputs.dailyName == periodItemFRC.outputs.dailyName
        })
        
        if let sectionIndex = sectionIndex {
            view?.tableViewDeleteRow(at: IndexPath(row: indexPath.row, section: sectionIndex))
            
            //insert cap
            if periodItemFRC.outputs.isEmpty && periodItemFRC.outputs.showingCapWhenTasksIsEmpty {
                view?.tableViewInsertRow(at: IndexPath(row: indexPath.row, section: sectionIndex))
            }
        }
    }
    
    func addSection(indexPath: IndexPath) {
        let section = indexPath.section
        let timePeriod = dataSource.tasksWithSections[section]
        
        let periodItem = periodItems.first(where: {
            $0.outputs.dailyName == timePeriod.dailyName
        })
        
        if let periodItem = periodItem {
            periodItemsFRC.insert(periodItem, at: section)
        }
    }
    
    func deleteSection(indexPath: IndexPath) {
        periodItemsFRC.remove(at: indexPath.section)
    }
    
}

extension TaskListViewModel: TaskListDataSourceObserver {
    func tasksWillChange() {
        view?.tableViewBeginUpdates()
    }
    
    func tasksDidChange() {
        tableViewFRCHelper.applyChanges()
        view?.tableViewEndUpdates()
        updateCounter()
    }
    
    func taskInserted(at newIndexPath: IndexPath) {
        tableViewFRCHelper.addTableChange(changeType: .insertItem, indexPath: newIndexPath)
    }
    
    func taskDeleted(at indexPath: IndexPath) {
        tableViewFRCHelper.addTableChange(changeType: .deleteItem, indexPath: indexPath)
    }
    
    func taskUpdated(at indexPath: IndexPath) {
        updateTaskInData(at: indexPath)
    }
    
    func taskSectionDelete(section: Int) {
        tableViewFRCHelper.addTableChange(changeType: .deleteSection, indexPath: IndexPath(row: 0, section: section))
    }
    
    func taskSectionInsert(section: Int) {
        tableViewFRCHelper.addTableChange(changeType: .insertSection, indexPath: IndexPath(row: 0, section: section))
    }
}

// MARK: NotificationTaskObserver

extension TaskListViewModel: NotificationTaskObserver {
    func onTapNotification(with id: String) {
        view?.editTask(taskUID: id)
    }
}

