//
//  DetailTaskCoordinator.swift
//  Tasker
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
    
    init(presenter: RouterType?, taskUID: String?) {
        self.router = presenter
        self.taskUID = taskUID
    }
    
    func start() {
        let vc = DetailTaskAssembly.createInstance(taskUID: taskUID, presenter: router)
        vc.onCalendarSelect = { date, outputs in
            self.openCalendar(date: date, calendarOutputs: outputs)
        }
        vc.onTimeReminderSelect = { date, outputs in
            self.openReminder(date: date, reminderOutputs: outputs)
        }
        vc.onShortcutSelect = { shortcutUID, outputs in
            self.selectShortcut(shortcutUID: shortcutUID, shortcutListOutputs: outputs)
        }
        router?.push(vc: vc, completion: { [weak self] in
            self?.parentCoordinator?.childDidFinish(self)
        }, transition: nil)
    }
    
    func selectShortcut(shortcutUID: String?, shortcutListOutputs: ShortcutListViewOutputs) {
        let vc = ShortcutListAssembly.createInstance(presenter: router)
        
        vc.selectShortcutHandler = { [weak shortcutListOutputs] uid in
            shortcutListOutputs?.selectedShortcutUID = uid
        }
        
        router?.push(vc: vc, completion: { [weak self] in
            self?.parentCoordinator?.childDidFinish(self)
        }, transition: CardModalTransitionController(viewController: vc, router: router))
    }
    
    func openCalendar(date: Date?, calendarOutputs: CalendarPickerViewOutputs) {
        let vc = CalendarPickerAssembly.createInstance(date: date, presenter: router)
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
        
        router?.push(vc: vc, completion: { [weak self] in
            self?.parentCoordinator?.childDidFinish(self)
        }, transition: nil)
    }
    
    func openReminder(date: Date?, reminderOutputs: TimePickerViewOutputs) {
        let vc = TimePickerAssembly.createInstance(date: date, presenter: router)
        vc.deleteReminderHandler = { [weak reminderOutputs] in
            reminderOutputs?.selectedReminderTime = nil
            reminderOutputs?.completionAfterCloseTimePicker()
        }
        vc.setReminderHandler = { [weak reminderOutputs] time in
            reminderOutputs?.selectedReminderTime = time
            reminderOutputs?.completionAfterCloseTimePicker()
        }
        
        router?.push(vc: vc, completion: { [weak self] in
            self?.parentCoordinator?.childDidFinish(self)
        }, transition: nil)
    }
    
}
