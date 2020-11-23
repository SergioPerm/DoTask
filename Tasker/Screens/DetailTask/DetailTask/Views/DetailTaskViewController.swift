//
//  DetailTaskViewController.swift
//  Tasker
//
//  Created by kluv on 28/09/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

class DetailTaskViewController: UIViewController, PresentableController {
    
    var presentableControllerViewType: PresentableControllerViewType
    var presenter: PresenterController?

    // MARK: ViewModel
    private var viewModel: DetailTaskViewModelType
    
    // MARK: Coordinates properties
    var viewOrigin: CGPoint = CGPoint(x: 0, y: 0)
    var viewWidth: CGFloat = 0.0
    var viewHeight: CGFloat = 0.0
            
    // MARK: Handlers
    var onCalendarSelect: ((_ selectedDate: Date?, _ vc: CalendarPickerViewOutputs) -> Void)?
    var onTimeReminderSelect: ((_ selectedTime: Date, _ vc: DetailTaskViewController) -> Void)?
    
    // MARK: View properties
    let topMargin: CGFloat = StyleGuide.DetailTask.topMargin
        
    let viewOriginOnStart: CGPoint = {
        guard let globalFrame = UIView.globalView?.frame else { return CGPoint.zero }
        let origin = CGPoint(x: globalFrame.origin.x, y: globalFrame.height)

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
    
    let placeholderLabel: UILabel = UILabel()
    
    let titleTextView: UITextView = {
        let textView = UITextView()
        textView.font = Font.detailTaskStandartTitle.uiFont
        textView.translatesAutoresizingMaskIntoConstraints = false

        return textView
    }()
        
    let accesoryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    var accesoryBottomConstraint: NSLayoutConstraint = NSLayoutConstraint()
            
    var importanceBtn: ImportanceButton?
    var calendarBtn: CalendarButton?
    var alarmBtn: AlarmButton?
    
    let saveBtn: UIButton = {
        return Button.makeStandartButton(image: UIImage(named: "checkmark")!)
    }()
    
    // MARK: Init
        
    init(viewModel: DetailTaskViewModelType, presenter: PresenterController?, presentableControllerViewType: PresentableControllerViewType) {
        
        self.viewModel = viewModel
        self.presenter = presenter
        self.presentableControllerViewType = presentableControllerViewType
                
        super.init(nibName: nil, bundle: nil)
    
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
        
        let correctionSpaceForBottomSafeArea = notification.name == UIResponder.keyboardWillHideNotification ? view.globalSafeAreaInsets.bottom : 0
        accesoryBottomConstraint.constant = convertedKeyboardEndFrame.minY - view.bounds.maxY - correctionSpaceForBottomSafeArea
        
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
        setupView()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showView()
    }
        
    // MARK: View SETUP
    
    private func setupView() {
        titleTextView.delegate = self
        
        let globalFrame = UIView.globalSafeAreaFrame
        view.frame = CGRect(origin: viewOriginOnStart, size: CGSize(width: globalFrame.width, height: globalFrame.height - (UIDevice.hasNotch ? 0 : topMargin)))
        
        view.addSubview(swipeCloseView)
        view.addSubview(dateLabel)
                      
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
                
        view.addSubview(titleTextView)
        titleTextView.delegate = self
        setupPlaceholder()
        
        let textViewBottomConstraint = titleTextView.bottomAnchor.constraint(equalTo: accesoryStackView.topAnchor)
        textViewBottomConstraint.priority = UILayoutPriority(rawValue: 250)
        
        accesoryBottomConstraint = accesoryStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.globalSafeAreaInsets.bottom)
                
        importanceBtn = ImportanceButton(onTapAction: { [weak self] in
            self?.viewModel.inputs.increaseImportance()
            }, importanceLevel: viewModel.outputs.importanceLevel)
        
        calendarBtn = CalendarButton(onTapAction: { [weak self] in
            self?.calendarTapAction()
            }, day: nil)
        
        alarmBtn = AlarmButton(onTapAction: { [weak self] in
            self?.reminderTapAction()
            })
                 
        accesoryStackView.addArrangedSubview(calendarBtn!)
        accesoryStackView.addArrangedSubview(alarmBtn!)
        accesoryStackView.addArrangedSubview(importanceBtn!)
        accesoryStackView.addArrangedSubview(saveBtn)
        
        saveBtn.addTarget(self, action: #selector(saveTaskAction(sender:)), for: .touchUpInside)
        
        view.addSubview(accesoryStackView)
        
        var constraints = [
            swipeCloseView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            swipeCloseView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            swipeCloseView.topAnchor.constraint(equalTo: view.topAnchor),
            swipeCloseView.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        constraints.append(contentsOf: [
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dateLabel.topAnchor.constraint(equalTo: swipeCloseView.bottomAnchor, constant: 14),
            dateLabel.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        constraints.append(contentsOf: [
            timeStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            timeStackView.topAnchor.constraint(equalTo: swipeCloseView.bottomAnchor, constant: 14),
            timeStackView.widthAnchor.constraint(equalToConstant: 79),
            clockImageView.heightAnchor.constraint(equalToConstant: 12),
            timeLabel.widthAnchor.constraint(equalToConstant: 60)
        ])
        
        constraints.append(contentsOf: [
            titleTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleTextView.topAnchor.constraint(equalTo: view.topAnchor, constant: 72),
            titleTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        constraints.append(contentsOf: [textViewBottomConstraint])
        
        constraints.append(contentsOf: [
            accesoryStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            accesoryBottomConstraint,
            accesoryStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            accesoryStackView.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        NSLayoutConstraint.activate(constraints)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(swipeToCloseAction(_:)))
        view.addGestureRecognizer(panGestureRecognizer)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapToCloseAction(_:)))
        swipeCloseView.addGestureRecognizer(tap)
        
        view.clipsToBounds = true
        view.backgroundColor = StyleGuide.DetailTask.viewBGColor
        let mask = CAShapeLayer()
        
        let cornerRadius = StyleGuide.DetailTask.viewCornerRadius
        mask.path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
        
        view.layer.mask = mask
    }
        
    // MARK: View animations
    
    private func showView() {
        let safeAreaFrame = UIView.globalSafeAreaFrame
        
        viewOrigin = CGPoint(x: safeAreaFrame.origin.x, y: safeAreaFrame.origin.y + topMargin)
        
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: {
                        self.view.frame.origin = self.viewOrigin
        }, completion: { (finished) in
            self.titleTextView.becomeFirstResponder()
        })
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
        
}

// MARK: Bind viewModel

extension DetailTaskViewController {
    private func bindViewModel() {
        viewModel.outputs.selectedDate.bind { [weak self] date in
            guard let date = date else {
                if let calendarBtn = self?.calendarBtn {
                    calendarBtn.day = nil
                }
                self?.dateLabel.text = ""
                return
            }
                         
            if let calendarBtn = self?.calendarBtn {
                calendarBtn.day = date
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            self?.dateLabel.text = dateFormatter.string(from: date)
        }
        
        viewModel.outputs.selectedTime.bind { [weak self] dateTime in
            guard let dateTime = dateTime else {
                self?.timeStackView.isHidden = true
                if let alarmBtn = self?.alarmBtn {
                    alarmBtn.alarmIsSet = false
                }
                return
            }
            
            self?.timeStackView.isHidden = false
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            
            self?.timeLabel.text = dateFormatter.string(from: dateTime)
            
            if let alarmBtn = self?.alarmBtn {
                alarmBtn.alarmIsSet = true
            }
        }
        
        self.titleTextView.text = viewModel.outputs.title
    }
}

// MARK: UITextViewDelegate

extension DetailTaskViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let updatedTitle = (textView.text as NSString?)?.replacingCharacters(in: range, with: text) {
            viewModel.inputs.setTitle(title: updatedTitle)
        }
        
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
            self.viewModel.inputs.saveTask()
            self.presenter?.pop(vc: self)
        }
    }
    
    func calendarTapAction() {
        titleTextView.resignFirstResponder()
        if let calendatAction = onCalendarSelect {
            calendatAction(viewModel.outputs.selectedDate.value, self)
        }
    }
    
    func reminderTapAction() {
        titleTextView.resignFirstResponder()
        
        var normalizeTime = viewModel.outputs.selectedDate.value ?? Date()
        if let taskTime = viewModel.outputs.selectedTime.value {
            normalizeTime = taskTime
            let calendar = Calendar.current.taskCalendar
            let timeComponents = calendar.dateComponents([.hour, .minute], from: normalizeTime)
            
            if let hour = timeComponents.hour, let minute = timeComponents.minute {
                guard let dateWithTime = Calendar.current.taskCalendar.date(bySettingHour: hour, minute: minute, second: 0, of: normalizeTime) else { return }
                normalizeTime = dateWithTime
            }
        } else {
            guard let dateWithTime = Calendar.current.taskCalendar.date(bySettingHour: 8, minute: 00, second: 0, of: normalizeTime) else { return }
            normalizeTime = dateWithTime
        }
        
        if let reminderAction = onTimeReminderSelect {
            reminderAction(normalizeTime, self)
        }
    }
    
    // MARK: -Close actions
    
    @objc func tapToCloseAction(_ recognizer: UITapGestureRecognizer) {
        hideView { [weak self] in
            guard let self = self else { return }
            self.presenter?.pop(vc: self)
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
                        self.presenter?.pop(vc: self)
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
                        self.presenter?.pop(vc: self)
                    }
                }
            }
        default:
            break
        }
    }
    
}

// MARK: CalendarPickerViewOutputs
extension DetailTaskViewController: CalendarPickerViewOutputs {
    var selectedCalendarDate: Date? {
        get {
            return viewModel.outputs.selectedDate.value
        }
        
        set {
            viewModel.inputs.setTaskDate(date: newValue)
        }
    }
    
    func comletionAfterCloseCalendar() {
        titleTextView.becomeFirstResponder()
    }
}

// MARK: TimePickerViewOutputs
extension DetailTaskViewController: TimePickerViewOutputs {
    var selectedReminderTime: Date? {
        get {
            return viewModel.outputs.selectedTime.value
        }
        set {
            viewModel.inputs.setReminder(date: newValue)
        }
    }

    func completionAfterCloseTimePicker() {
        titleTextView.becomeFirstResponder()
    }
}
