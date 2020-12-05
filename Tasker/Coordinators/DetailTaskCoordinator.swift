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
    
    var presenter: PresenterController?
    private var taskUID: String?
    
    init(presenter: PresenterController?, taskUID: String?) {
        self.presenter = presenter
        self.taskUID = taskUID
    }
    
    func start() {
        let vc = DetailTaskAssembly.createInstance(taskUID: taskUID, presenter: presenter)
        vc.onCalendarSelect = { date, outputs in
            self.openCalendar(date: date, calendarOutputs: outputs)
        }
        vc.onTimeReminderSelect = { date, outputs in
            self.openReminder(date: date, reminderOutputs: outputs)
        }
        presenter?.push(vc: vc, completion: { [weak self] in
            self?.parentCoordinator?.childDidFinish(self)
        })
    }
    
    func openCalendar(date: Date?, calendarOutputs: CalendarPickerViewOutputs) {
        let vc = CalendarPickerAssembly.createInstance(date: date, presenter: presenter)
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
        
        presenter?.push(vc: vc, completion: { [weak self] in
            self?.parentCoordinator?.childDidFinish(self)
        })
    }
    
    func openReminder(date: Date?, reminderOutputs: TimePickerViewOutputs) {
        let vc = TimePickerAssembly.createInstance(date: date, presenter: presenter)
        vc.deleteReminderHandler = { [weak reminderOutputs] in
            reminderOutputs?.selectedReminderTime = nil
            reminderOutputs?.completionAfterCloseTimePicker()
        }
        vc.setReminderHandler = { [weak reminderOutputs] time in
            reminderOutputs?.selectedReminderTime = time
            reminderOutputs?.completionAfterCloseTimePicker()
        }
        
        presenter?.push(vc: vc, completion: { [weak self] in
            self?.parentCoordinator?.childDidFinish(self)
        })
    }
    
}
