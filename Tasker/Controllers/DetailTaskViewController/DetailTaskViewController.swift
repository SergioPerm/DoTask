//
//  DetailTaskViewController.swift
//  Tasker
//
//  Created by kluv on 28/09/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

class DetailTaskViewController: UIViewController {

    // MARK: Coordinates properties
    var viewOrigin: CGPoint = CGPoint(x: 0, y: 0)
    var viewWidth: CGFloat = 0.0
    var viewHeight: CGFloat = 0.0
    
    
    // MARK: Data model
    var taskModel: TaskModel
    
    var selectedDate: Date? {
        didSet {
            guard let selectedDate = selectedDate else {
                let calendarImage = UIImage(named: "dateCalendar")
                taskModel.taskDate = nil
                if let calendarBtn = calendarBtn {
                    calendarBtn.day = nil
                }
                dateLabel.text = ""
                return
            }
            
            func setDateInModel(timeComponents: DateComponents) {
                if let hour = timeComponents.hour, let minute = timeComponents.minute {
                    taskModel.taskDate = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: selectedDate)
                }
            }
            
            if let taskDate = taskModel.taskDate {
                let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: taskDate)
                setDateInModel(timeComponents: timeComponents)
            } else {
                let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: Date())
                setDateInModel(timeComponents: timeComponents)
            }
                        
            if let calendarBtn = calendarBtn {
                calendarBtn.day = selectedDate
            }
                        
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            dateLabel.text = dateFormatter.string(from: selectedDate)
        }
    }
    
    var selectedTime: Date? {
        didSet {
            guard let selectedTime = selectedTime else {
                taskModel.reminderDate = false
                timeStackView.isHidden = true
                if let alarmBtn = alarmBtn {
                    alarmBtn.alarmIsSet = false
                }
                return
            }
            taskModel.taskDate = selectedTime
            
            timeStackView.isHidden = false
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            
            timeLabel.text = dateFormatter.string(from: selectedTime)
            
            if let alarmBtn = alarmBtn {
                alarmBtn.alarmIsSet = true
            }
            
            taskModel.reminderDate = true
        }
    }
    
    // MARK: Handlers
    var taskWillSave: (_ taskModel: TaskModel, _ vc: DetailTaskViewController) -> Void
    var onCalendarSelect: (_ selectedDate: Date, _ vc: DetailTaskViewController) -> Void
    var onTimeReminderSelect: (_ selectedTime: Date, _ vc: DetailTaskViewController) -> Void
    var onCancelTaskHandler: (_ vc: DetailTaskViewController) -> Void
    
    // MARK: View properties
    let topInset: CGFloat = 40
    
    let screenSize: CGRect = {
        return UIScreen.main.bounds
    }()
    
    let viewOriginOnStart: CGPoint = {
        let screenSize = UIScreen.main.bounds
        let origin = CGPoint(x: screenSize.origin.x, y: screenSize.height)
        
        return origin
    }()
    
    let swipeCloseView: UIView = {
        let swipeView = UIView()
        swipeView.translatesAutoresizingMaskIntoConstraints = false
        swipeView.backgroundColor = .clear

        var chevron = UIImageView()
        if #available(iOS 13.0, *) {
            chevron = UIImageView(image: UIImage(systemName: "chevron.compact.down"))
        } else {
            chevron = UIImageView(image: UIImage(named: "chevron"))
        }
        chevron.contentMode = .scaleAspectFit
        chevron.translatesAutoresizingMaskIntoConstraints = false
        chevron.tintColor = #colorLiteral(red: 0.8901960784, green: 0.8901960784, blue: 0.8901960784, alpha: 1)
        
        swipeView.addSubview(chevron)
        
        let constraints = [
            chevron.centerYAnchor.constraint(equalTo: swipeView.centerYAnchor),
            chevron.centerXAnchor.constraint(equalTo: swipeView.centerXAnchor),
            chevron.widthAnchor.constraint(equalTo: chevron.heightAnchor, multiplier: 2),
            chevron.heightAnchor.constraint(equalToConstant: 27)
        ]
        
        NSLayoutConstraint.activate(constraints)
                        
        return swipeView
    }()
    
    let dateLabel: UILabel = {
        return Label.makeDetailTaskStandartLabel(textColor: .systemGray)
    }()
    
    let timeLabel: UILabel = {
        let label = Label.makeDetailTaskStandartLabel(textColor: .systemGray)
        label.textAlignment = .right
        return label
    }()
    
    let timeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    let titleTextView: UITextView = {
        let textView = UITextView()
        textView.font = Font.detailTaskStandartTitle.uiFont
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    let placeholderLabel: UILabel = UILabel()
    
    let accesoryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    var accesoryBottomConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
//    let calendarBtn: UIButton = {
//        return Button.makeStandartButtonWithImage(image: UIImage(named: "dateCalendar")!)
//    }()
    
    let reminderBtn: UIButton = {
        return Button.makeStandartButtonWithImage(image: UIImage(named: "clockAlarm")!)
    }()
    
    var importanceBtn: ImportanceButton?
    var calendarBtn: CalendarButton?
    var alarmBtn: AlarmButton?
    
    let saveBtn: UIButton = {
        return Button.makeStandartButtonWithImage(image: UIImage(named: "checkmark")!)
    }()
    
    // MARK: Init
        
    init(taskModel: TaskModel?, onSave saveTaskHandler: @escaping (_ taskModel: TaskModel, _ vc: DetailTaskViewController) -> Void,
         onCancel onCancelTaskHandler: @escaping(_ vc: DetailTaskViewController) -> Void,
         onCalendarSelect calendarSelectHandler: @escaping (_ selectedDate: Date, _ vc: DetailTaskViewController) -> Void,
         onTimeReminderSelect timeReminderSelectHandler: @escaping (_ selectedTime: Date, _ vc: DetailTaskViewController) -> Void) {
        
        self.taskModel = taskModel ?? TaskModel()
            
        self.taskWillSave = saveTaskHandler
        self.onCancelTaskHandler = onCancelTaskHandler
        self.onCalendarSelect = calendarSelectHandler
        self.onTimeReminderSelect = timeReminderSelectHandler
                
        super.init(nibName: nil, bundle: nil)
    
        self.selectedCalendarDate = self.taskModel.taskDate
        self.selectedReminderTime = self.taskModel.reminderDate ? self.taskModel.taskDate : nil
        self.titleTextView.text = taskModel?.title
        
        setupNotifications()
    }
    
    deinit {
        print("detail task de init")
        deleteNotifications()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Notifications
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func deleteNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShowNotification(notification: NSNotification) {
        updateBottomLayoutConstraintWithNotification(notification: notification)
    }
    
    @objc func keyboardWillHideNotification(notification: NSNotification) {
        updateBottomLayoutConstraintWithNotification(notification: notification)
    }
    
    private func updateBottomLayoutConstraintWithNotification(notification: NSNotification) {
        let userInfo = notification.userInfo!
        
        let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let keyboardEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let convertedKeyboardEndFrame = view.convert(keyboardEndFrame, from: view.window)
        let rawAnimationCurve = (notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).uint32Value << 16
        let animationCurve = UIView.AnimationOptions.init(rawValue: UInt(rawAnimationCurve))
        
        accesoryBottomConstraint.constant = convertedKeyboardEndFrame.minY - view.bounds.maxY
        
        UIView.animate(withDuration: animationDuration,
                       delay: 0.0,
                       options: [.beginFromCurrentState, animationCurve],
                       animations: {
                        self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    
    // MARK: View Life-Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewOrigin()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showView()
    }
        
    // MARK: View SETUP
    
    private func setupView() {
        
        titleTextView.delegate = self
        
        view.frame = CGRect(origin: viewOriginOnStart, size: CGSize(width: viewWidth, height: screenSize.height - viewOrigin.y + 16))
        view.clipsToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapToCloseAction(_:)))
        swipeCloseView.addGestureRecognizer(tap)
        
        view.addSubview(swipeCloseView)
        
        var constraints = [
            swipeCloseView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            swipeCloseView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            swipeCloseView.topAnchor.constraint(equalTo: view.topAnchor),
            swipeCloseView.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        view.addSubview(dateLabel)
        
        constraints.append(contentsOf: [
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dateLabel.topAnchor.constraint(equalTo: swipeCloseView.bottomAnchor, constant: 14),
            dateLabel.widthAnchor.constraint(equalToConstant: 100)
        ])
              
        var clockImageView = UIImageView()
        if #available(iOS 13.0, *) {
            clockImageView = UIImageView(image: UIImage(systemName: "alarm"))
        } else {
            clockImageView = UIImageView(image: UIImage(named: "alarm"))
        }
        clockImageView.tintColor = .systemGray
        clockImageView.contentMode = .scaleAspectFit
        
        timeStackView.addArrangedSubview(clockImageView)
        timeStackView.addArrangedSubview(timeLabel)
        
        view.addSubview(timeStackView)
        
        constraints.append(contentsOf: [
            timeStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            timeStackView.topAnchor.constraint(equalTo: swipeCloseView.bottomAnchor, constant: 14),
            timeStackView.widthAnchor.constraint(equalToConstant: 79),
            clockImageView.heightAnchor.constraint(equalToConstant: 12),
            timeLabel.widthAnchor.constraint(equalToConstant: 60)
        ])
        
        view.addSubview(titleTextView)
        
        constraints.append(contentsOf: [
            titleTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleTextView.topAnchor.constraint(equalTo: view.topAnchor, constant: 72),
            titleTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        titleTextView.delegate = self
        
        setupPlaceholder()
        
        let textViewBottomConstraint = titleTextView.bottomAnchor.constraint(equalTo: accesoryStackView.topAnchor, constant: 24)
        textViewBottomConstraint.priority = UILayoutPriority(rawValue: 250)
        
        accesoryBottomConstraint = accesoryStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        
        constraints.append(contentsOf: [textViewBottomConstraint])
        
        importanceBtn = ImportanceButton(onTapAction: { [weak self] in
            self?.importanceLevelTapAction()
            }, importanceLevel: Int(taskModel.importanceLevel))
        
        calendarBtn = CalendarButton(onTapAction: { [weak self] in
            self?.calendarTapAction()
            }, day: selectedDate)
        
        alarmBtn = AlarmButton(onTapAction: { [weak self] in
            self?.reminderTapAction()
            }, alarmSet: taskModel.reminderDate)
        
        importanceBtn!.importanceLevel = ImportanceLevel(rawValue: Int(taskModel.importanceLevel))!
         
        accesoryStackView.addArrangedSubview(calendarBtn!)
        accesoryStackView.addArrangedSubview(alarmBtn!)
        accesoryStackView.addArrangedSubview(importanceBtn!)
        accesoryStackView.addArrangedSubview(saveBtn)
        
        saveBtn.addTarget(self, action: #selector(saveTaskAction(sender:)), for: .touchUpInside)
        
        view.addSubview(accesoryStackView)
        
        constraints.append(contentsOf: [
            accesoryStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            accesoryBottomConstraint,
            accesoryStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            accesoryStackView.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        NSLayoutConstraint.activate(constraints)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(swipeToCloseAction(_:)))
        view.addGestureRecognizer(panGestureRecognizer)
        
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        view.layer.cornerRadius = 16
        view.layer.shadowOffset = CGSize(width: 0, height: 6)
        view.layer.shadowRadius = 6
        view.layer.shadowOpacity = 0.3
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 16, height: 16)).cgPath
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
                
    }
    
    // MARK: Setup View Origin
    
    private func setupViewOrigin() {
        let safeAreaFrame = UIView.globalSafeAreaFrame
        
        viewOrigin = CGPoint(x: safeAreaFrame.origin.x, y: safeAreaFrame.origin.y + topInset)
        viewWidth = safeAreaFrame.width
        viewHeight = safeAreaFrame.height
    }
    
    private func showView() {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: {
                        self.view.frame.origin = self.viewOrigin
        }, completion: { (finished) in
            self.titleTextView.becomeFirstResponder()
        })
    }
    
    // MARK: Setup TextView place holder
    
    private func setupPlaceholder() {
        placeholderLabel.text = "Task description"
        placeholderLabel.font = Font.detailTaskStandartTitle.uiFont
        placeholderLabel.sizeToFit()
        titleTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (titleTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !titleTextView.text.isEmpty
    }
        
    private func hideView(completion: @escaping ()->()) {
        titleTextView.resignFirstResponder()
        
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: {
                        self.view.frame.origin = self.viewOriginOnStart
        }, completion: { (finished) in
            completion()
        })
    }
}

// MARK: UITextViewDelegate

extension DetailTaskViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let updatedTitle = (textView.text as NSString?)?.replacingCharacters(in: range, with: text)
        taskModel.title = updatedTitle!
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}

// MARK: Actions

extension DetailTaskViewController {
    
    // MARK: -Accessory view actions
    
    @objc func saveTaskAction(sender: UIButton) {
        if titleTextView.text == "" {
            titleTextView.shake(duration: 1)
            return
        }
        
        hideView { [weak self] in
            guard let self = self else { return }
            self.taskWillSave(self.taskModel, self)
        }
    }
    
    func calendarTapAction() {
        titleTextView.resignFirstResponder()
        onCalendarSelect(taskModel.taskDate ?? Date(), self)
    }
    
    func reminderTapAction() {
        titleTextView.resignFirstResponder()
        
        var taskTime = taskModel.taskDate ?? Date()
        if !taskModel.reminderDate {
            let calendar = Calendar.current.taskCalendar
            if calendar.isDateInToday(taskTime) {
                let timeComponents = calendar.dateComponents([.hour, .minute], from: Date())
                
                if let hour = timeComponents.hour, let minute = timeComponents.minute {
                    guard let dateWithTime = Calendar.current.taskCalendar.date(bySettingHour: hour, minute: minute, second: 0, of: taskTime) else { return }
                    taskTime = dateWithTime
                }
                
            
            } else {
                guard let dateWithTime = Calendar.current.taskCalendar.date(bySettingHour: 8, minute: 00, second: 0, of: taskTime) else { return }
                taskTime = dateWithTime
            }
        }
        
        onTimeReminderSelect(taskTime, self)
    }
    
    func importanceLevelTapAction() {
        taskModel.importanceLevel += 1
    }
    
    // MARK: -Close actions
    
    @objc func tapToCloseAction(_ recognizer: UITapGestureRecognizer) {
        hideView { [weak self] in
            guard let self = self else { return }
            self.onCancelTaskHandler(self)
        }
    }
    
    @objc func swipeToCloseAction(_ recognizer: UIPanGestureRecognizer) {
        let gestureIsDraggingFromTopToBottom = recognizer.velocity(in: view).y > 0
        if !gestureIsDraggingFromTopToBottom { return }
        
        switch recognizer.state {
        case .changed:
            if let rView = recognizer.view {
                
                if rView.frame.origin.y < viewOrigin.y {
                    rView.frame.origin = viewOrigin
                }
                                
                var draggingDistance = recognizer.translation(in: view).y

                draggingDistance *= 0.2

                let swipePositionY = rView.frame.origin.y + draggingDistance

                if swipePositionY > viewOrigin.y {
                    rView.frame.origin.y = rView.frame.origin.y + draggingDistance
                    recognizer.setTranslation(CGPoint.zero, in: view)
                }

                if rView.frame.origin.y > viewOrigin.y + 45 {
                    hideView { [weak self] in
                        guard let self = self else { return }
                        self.onCancelTaskHandler(self)
                    }
                }
            }
        case .ended:
            if let rView = recognizer.view {
                if rView.frame.origin.y <= viewOrigin.y + 45 {
                    UIView.animate(withDuration: 0.3) {
                        self.view.frame.origin.y = self.viewOrigin.y
                    }
                } else {
                    hideView { [weak self] in
                        guard let self = self else { return }
                        self.onCancelTaskHandler(self)
                    }
                }
            }
        default:
            break
        }
    }
    
}

// MARK: CelendarPickerInstance
extension DetailTaskViewController: CalendarPickerInstance {
    func closeCalendar() {
        titleTextView.becomeFirstResponder()
    }
    
    var selectedCalendarDate: Date? {
        get {
            return taskModel.taskDate
        }
        
        set {
            selectedDate = newValue
        }
    }
}

// MARK: TimePickerInstance
extension DetailTaskViewController: TimePickerInstance {
    var selectedReminderTime: Date? {
        get {
            return taskModel.taskDate
        }
        set {
            selectedTime = newValue
        }
    }
    
    func closeTimePicker() {
        titleTextView.becomeFirstResponder()
    }
    
    
}
