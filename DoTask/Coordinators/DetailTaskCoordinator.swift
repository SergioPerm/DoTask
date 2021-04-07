//
//  DetailTaskCoordinator.swift
//  DoTask
//
//  Created by kluv on 23/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

class DetailTaskCoordinator: NSObject, Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    
    var router: RouterType?
    private var taskUID: String?
    private var shortcutUID: String?
    private var taskDate: Date?
    
    init(router: RouterType?, taskUID: String?, shortcutUID: String?, taskDate: Date?) {
        self.router = router
        self.taskUID = taskUID
        self.shortcutUID = shortcutUID
        self.taskDate = taskDate
    }
    
    func start() {
        let vc: DetailTaskViewType = taskUID == nil ? AppDI.resolve(withTag: DetailTaskNewViewController.self) : AppDI.resolve(withTag: DetailTaskEditViewController.self)
        
        vc.setTaskUID(UID: taskUID)
        vc.setFilter(filter: TaskListFilter(shortcutFilter: shortcutUID, dayFilter: taskDate))
        
        vc.onCalendarSelect = { date, outputs in
            self.openCalendar(date: date, calendarOutputs: outputs)
        }
        vc.onTimeReminderSelect = { date, outputs in
            self.openReminder(date: date, reminderOutputs: outputs)
        }
        vc.onShortcutSelect = { [weak self] shortcutUID, outputs in
            self?.selectShortcut(shortcutUID: shortcutUID, shortcutListOutputs: outputs)
        }

        let transition = PopUpModalTransitionController(viewController: vc, interactionView: vc.scrollContentView, router: router)

        router?.push(vc: vc, completion: { [weak self] in
            self?.parentCoordinator?.childDidFinish(self)
        }, transition: transition)
    }
    
    func selectShortcut(shortcutUID: String?, shortcutListOutputs: ShortcutListViewOutputs) {
        let vc: ShortcutListViewType = AppDI.resolve()

        vc.selectShortcutHandler = { [weak shortcutListOutputs] uid in
            shortcutListOutputs?.selectedShortcutUID = uid
        }

        let transition = CardModalTransitionController(viewController: vc, interactionView: vc.tableView, router: router)

        router?.push(vc: vc, completion: { [weak self] in
            self?.parentCoordinator?.childDidFinish(self)
        }, transition: transition)
    }
    
    func openCalendar(date: Date?, calendarOutputs: CalendarPickerViewOutputs) {
        let vc: CalendarPickerViewType = AppDI.resolve()//CalendarPickerAssembly.createInstance(date: date, presenter: router)
        
        vc.setSelectDay(date: date)
        
        vc.saveDatePickerHandler = { [weak calendarOutputs] in
            calendarOutputs?.comletionAfterCloseCalendar()
        }
        vc.cancelDatePickerHandler = { [weak calendarOutputs] in
            calendarOutputs?.selectedCalendarDate = date
            calendarOutputs?.comletionAfterCloseCalendar()
        }
        vc.selectedDateChangedHandler = { [weak calendarOutputs] date in
            calendarOutputs?.selectedCalendarDate = date
        }
                
        let transition = ZoomModalTransitionController()
        
        router?.push(vc: vc, completion: { [weak self] in
            self?.parentCoordinator?.childDidFinish(self)
        }, transition: transition)
        

        
        
    }
    
    func openReminder(date: Date?, reminderOutputs: TimePickerViewOutputs) {
        let vc: TimePickerViewType = AppDI.resolve()//TimePickerAssembly.createInstance(date: date, presenter: router)
        
        vc.setBaseTime(time: date)
        
        vc.deleteReminderHandler = { [weak reminderOutputs] in
            reminderOutputs?.selectedReminderTime = nil
            reminderOutputs?.completionAfterCloseTimePicker()
        }
        vc.setReminderHandler = { [weak reminderOutputs] time in
            reminderOutputs?.selectedReminderTime = time
            reminderOutputs?.completionAfterCloseTimePicker()
        }
        
        let transition = ZoomModalTransitionController()
        
        router?.push(vc: vc, completion: { [weak self] in
            self?.parentCoordinator?.childDidFinish(self)
        }, transition: transition)
    }
    
}
