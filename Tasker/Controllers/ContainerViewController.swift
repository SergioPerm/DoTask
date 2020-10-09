//
//  ContainerViewController.swift
//  Tasker
//
//  Created by kluv on 28/09/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    // MARK: Main View
    
    var mainViewController: TaskListViewController!
    
    // MARK: View Life-cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        configureMainViewConrtoller()
    }
}

extension ContainerViewController {
    
    // MARK: Setup
    
    func configureMainViewConrtoller() {
        mainViewController = TaskListViewController(editTaskAction: { [weak self] taskModel in
            self?.editTask(taskModel: taskModel)
        })
        
        _ = UINavigationController(rootViewController: mainViewController)
                
        let navLabel = UILabel()
        let navTitle = NSMutableAttributedString(string: "Task", attributes:[
            NSAttributedString.Key.foregroundColor: Color.blueColor.uiColor,
            NSAttributedString.Key.font: Font.mainTitle.uiFont])

        navTitle.append(NSMutableAttributedString(string: "er", attributes:[
            NSAttributedString.Key.font: Font.mainTitle2.uiFont,
            NSAttributedString.Key.foregroundColor: Color.pinkColor.uiColor]))

        navLabel.attributedText = navTitle
        mainViewController.navigationItem.titleView = navLabel
        
        if let navBar = mainViewController.navigationController?.navigationBar {
            
            navBar.standardAppearance.backgroundColor = UIColor.clear
            navBar.standardAppearance.backgroundEffect = nil
            navBar.standardAppearance.shadowImage = UIImage()
            navBar.standardAppearance.shadowColor = .clear
            navBar.standardAppearance.backgroundImage = UIImage()
            
        }
        
        self.add(mainViewController.navigationController!)
    }
        
    // MARK: Views actions
    
    func editTask(taskModel: TaskModel?) {
        let taskModel = taskModel ?? nil
                
        let detailTaskViewController = DetailTaskViewController(taskModel: taskModel, onSave: { [weak self] taskModel, detailVC in
            if taskModel.isNew {
                self?.mainViewController.viewModel.addTask(from: taskModel)
            } else {
                self?.mainViewController.viewModel.updateTask(from: taskModel)
            }
            
            detailVC.remove()
            self?.view.removeDimmedView()
        }, onCancel: { [weak self] detailVC in
            detailVC.remove()
            self?.view.removeDimmedView()
        }, onCalendarSelect: { [weak self] currentDate, detailVC in
            self?.openDatePicker(withDate: currentDate, for: detailVC)
        }, onTimeReminderSelect: { [weak self] currentTime, detailVC in
            self?.openTimePicker(withTime: currentTime, for: detailVC)
        })
        
        add(detailTaskViewController)
        view.showDimmedBelowSubview(subview: detailTaskViewController.view, for: view)
    }
        
    func openTimePicker(withTime date: Date, for instanceVC: TimePickerInstance) {
        let timePicker = TimePickerViewController(baseTime: date, onDelete: { [weak self, weak instanceVC] pickerVC in
            instanceVC?.selectedReminderTime = nil
            instanceVC?.closeTimePicker()
            pickerVC.remove()
            self?.view.removeDimmedView()
        }, onSet: { [weak self, weak instanceVC] pickerVC, setTime in
            instanceVC?.selectedReminderTime = setTime
            instanceVC?.closeTimePicker()
            pickerVC.remove()
            self?.view.removeDimmedView()
        })
        
        add(timePicker)
        view.showDimmedBelowSubview(subview: timePicker.view, for: view)
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
        
        add(calendarPicker)
        view.showDimmedBelowSubview(subview: calendarPicker.view, for: view)
    }
}

