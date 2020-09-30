//
//  ContainerViewController.swift
//  Tasker
//
//  Created by kluv on 28/09/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    var mainViewController: TaskListViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        view.backgroundColor = .clear
        
        configureMainViewConrtoller()
        // Do any additional setup after loading the view.
    }
    
    func configureMainViewConrtoller() {
        
        mainViewController = TaskListViewController(editTaskAction: { [weak self] taskModel in
            self?.editTask(taskModel: taskModel)
        })
        
        _ = UINavigationController(rootViewController: mainViewController)
        
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAction(sender:)))
        
        mainViewController.navigationItem.rightBarButtonItem = addItem
        mainViewController.title = "Tasker"
        
        self.add(mainViewController.navigationController!)
        
    }
    
    @objc func addAction(sender: UIBarButtonItem) {
        let detailTaskViewController = DetailTaskViewController(taskModel: nil, onSave: { [weak self] taskModel, detailVC in
            self?.mainViewController.viewModel.addTask(from: taskModel)
            detailVC.remove()
        }, onCancel: { detailVC in
            detailVC.remove()
        }, onCalendarSelect: { [weak self] currentDate, detailVC in
            self?.openDatePicker(withDate: currentDate, for: detailVC)
        }, onTimeReminderSelect: { [weak self] currentTime, detailVC in
                
        })
        addSubviewAtIndex(detailTaskViewController, at: 1)
    }
    
    func editTask(taskModel: TaskModel) {
        let detailTaskViewController = DetailTaskViewController(taskModel: taskModel, onSave: { [weak self] taskModel, detailVC in
            self?.mainViewController.viewModel.updateTask(from: taskModel)
            detailVC.remove()
        }, onCancel: { detailVC in
            detailVC.remove()
        }, onCalendarSelect: { [weak self] currentDate, detailVC in
            self?.openDatePicker(withDate: currentDate, for: detailVC)
        }, onTimeReminderSelect: { [weak self] currentTime, detailVC in
                let test = ""
        })
        addSubviewAtIndex(detailTaskViewController, at: 1)
    }
    
    func openTimePicker(withTime date: Date, for instanceVC: TimePickerInstance) {
        
    }
    
    func openDatePicker(withDate date: Date, for instanceVC: CalendarPickerInstance) {
        let calendarPicker = CalendarPickerViewController(baseDate: Date(), selectDate: date, onSelectedDateChanged: { [weak instanceVC] selectDate in
            instanceVC?.selectedCalendarDate = selectDate
        }, onCancel: { [weak self, weak instanceVC] pickerVC in
            instanceVC?.selectedCalendarDate = date
            instanceVC?.closeCalendar()
            pickerVC.remove()
            self?.view.removeDimmedView()
        }, onSave: { [weak self, weak instanceVC] pickerVC in
            instanceVC?.closeCalendar()
            pickerVC.remove()
            self?.view.removeDimmedView()
        })
        
        addSubviewAtIndex(calendarPicker, at: 2)
        view.showDimmedBelowSubview(subview: calendarPicker.view, for: view)
    }
}
