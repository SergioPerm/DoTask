//
//  ContainerViewController.swift
//  Tasker
//
//  Created by kluv on 28/09/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    // MARK: Menu
    
    enum SlideOutMenuState {
      case menuCollapsed
      case menuExpanded
    }

    var currentState: SlideOutMenuState = .menuCollapsed
    var screenHalfQuarterWidth: CGFloat!
    var offsetToMenuExpand: CGFloat!
    var isMove = false
    
    // MARK: Main View
    
    var mainViewController: TaskListViewController!
    var mainNavigationController: UINavigationController!
    var menuNavigationController: UINavigationController!
        
    // MARK: View Life-cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        screenHalfQuarterWidth = view.bounds.width/8
        offsetToMenuExpand = screenHalfQuarterWidth*2
                
        configureMainViewConrtoller()
    }
}

extension ContainerViewController {
    
    // MARK: Setup
    
    func configureMainViewConrtoller() {
        mainViewController = TaskListViewController(editTaskAction: { [weak self] taskModel in
            self?.editTask(taskModel: taskModel)
        })
        
        mainNavigationController = UINavigationController(rootViewController: mainViewController)
                
        let navLabel = UILabel()
        let navTitle = NSMutableAttributedString(string: "Task", attributes:[
            NSAttributedString.Key.foregroundColor: Color.blueColor.uiColor,
            NSAttributedString.Key.font: Font.mainTitle.uiFont])

        navTitle.append(NSMutableAttributedString(string: "er", attributes:[
            NSAttributedString.Key.font: Font.mainTitle2.uiFont,
            NSAttributedString.Key.foregroundColor: Color.pinkColor.uiColor]))

        navLabel.attributedText = navTitle
        mainViewController.navigationItem.titleView = navLabel
        
        let menuView = CalendarButton(onTapAction: { [weak self] in
            self?.toggleMenu()
        }, day: nil)
                
        let menuBtn = UIBarButtonItem(customView: menuView)
        menuBtn.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBtn.customView?.heightAnchor.constraint(equalToConstant: 44).isActive = true
        menuBtn.customView?.widthAnchor.constraint(equalToConstant: 44).isActive = true
        
        
        mainViewController.navigationItem.leftBarButtonItem = menuBtn
        
        menuView.sizeToFit()
        
        if let navBar = mainViewController.navigationController?.navigationBar {
            if #available(iOS 13.0, *) {
                navBar.standardAppearance.backgroundColor = UIColor.clear
                navBar.standardAppearance.backgroundEffect = nil
                navBar.standardAppearance.shadowImage = UIImage()
                navBar.standardAppearance.shadowColor = .clear
                navBar.standardAppearance.backgroundImage = UIImage()
            } else {
                // Fallback on earlier versions
                navBar.backgroundColor = .clear
                navBar.setBackgroundImage(UIImage(), for:.default)
                navBar.shadowImage = UIImage()
                navBar.layoutIfNeeded()
            }
        }
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        mainNavigationController.view.addGestureRecognizer(panGestureRecognizer)
        
        add(mainNavigationController)
    }
        
    func configureMenuViewController() {
        let menuVC = LeftMenuViewController(testTap: {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.red
            
            self.toggleMenu()
            self.mainNavigationController.pushViewController(vc, animated: true)
        })
        
        if let menuNavigationController = menuVC.navigationController {
            self.menuNavigationController = menuNavigationController
            add(menuNavigationController, atIndex: 0)
        }
    }
    
    // MARK: Views actions
    
    func toggleMenu() {
        let notAlreadyExpanded = currentState != .menuExpanded
        
        if notAlreadyExpanded {
            configureMenuViewController()
        }
        
        animateLeftmenu(shouldExpand: notAlreadyExpanded)
    }
    
    @objc func openCalendarPlan(sender: UIBarButtonItem) {
//        let vc = CalendarPlanViewController(startPoint: sender.getCenterPositionRelativeToGlobalView())
//        add(vc)
    }
    
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
   
        add(detailTaskViewController, withDimmedBack: true)
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
        
        add(timePicker, withDimmedBack: true)
    }
    
    func openDatePicker(withDate date: Date, for instanceVC: CalendarPickerInstance) {

        let calendarPicker = CalendarPickerViewController(selectedDate: date, onSelectedDateChanged: { [weak instanceVC] selectDate in
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
        
        add(calendarPicker, withDimmedBack: true)
    }
    
    // MARK: Menu behavior
    
    func animateLeftmenu(shouldExpand: Bool) {
        
        if shouldExpand {
            currentState = .menuExpanded
            animateCenterPanel(targetPosition: screenHalfQuarterWidth*4) { _ in
                self.isMove = !self.isMove
            }
        } else {
            animateCenterPanel(targetPosition: 0) { _ in
                self.currentState = .menuCollapsed
                self.menuNavigationController.remove()
            }
        }
        
    }
    
    func animateCenterPanel(targetPosition: CGFloat, completion: ((Bool) -> Void)? = nil) {
        
        let dampingRatio: CGFloat = targetPosition == 0 ? 1 : 0.6
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: dampingRatio,
                       initialSpringVelocity: 0,
                       options: .curveEaseInOut,
                       animations: {
                        self.mainNavigationController.view.frame.origin.x = targetPosition
        }, completion: completion)
        
    }
    
    // MARK: Gesture recognizer
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let gestureIsDraggingFromLeftToRight = recognizer.velocity(in: view).x > 0
    
        switch recognizer.state {
        case .began:
            if gestureIsDraggingFromLeftToRight {
                configureMenuViewController()
            }
        
        case .changed:
            if let rView = recognizer.view {
                                
                let centerX = view.bounds.width/2
                var draggingDisctance = recognizer.translation(in: view).x
                let currentCenterX = rView.center.x
                
                //Only left menu
                if (currentCenterX + draggingDisctance) < centerX {
                    draggingDisctance -= ((currentCenterX + draggingDisctance) - centerX)
                }
                
                if rView.frame.origin.x > offsetToMenuExpand {
                    draggingDisctance *= 1.5
                }
                
                rView.center.x = rView.center.x + draggingDisctance
                recognizer.setTranslation(CGPoint.zero, in: view)

            }
            
        case .ended:
            if let rView = recognizer.view {
                let hasMoveGreaterThanHalfway = rView.frame.origin.x > offsetToMenuExpand
                
                animateLeftmenu(shouldExpand: hasMoveGreaterThanHalfway)
            }
            
        default:
            break
            
        }
        
    }
    
}

