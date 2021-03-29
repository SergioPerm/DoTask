//
//  DetailTaskViewController.swift
//  DoTask
//
//  Created by kluv on 28/09/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

class DetailTaskNewViewController: UIViewController, DetailTaskViewType, PresentableController {
    
    var presentableControllerViewType: PresentableControllerViewType
    var router: RouterType?
    var persistentType: PersistentViewControllerType?
    
    // MARK: ViewModel
    private var viewModel: DetailTaskViewModelType
    
    // MARK: Coordinates properties
    private var viewOrigin: CGPoint = CGPoint(x: 0, y: 0)
    private var viewWidth: CGFloat = 0.0
    private var viewHeight: CGFloat = 0.0
            
    // MARK: Handlers
    var onCalendarSelect: ((_ selectedDate: Date?, _ vc: CalendarPickerViewOutputs) -> Void)? {
        didSet {
            viewModel.inputs.setCalendarHandler(onCalendarSelect: onCalendarSelect)
        }
    }
    
    var onTimeReminderSelect: ((_ selectedTime: Date, _ vc: TimePickerViewOutputs) -> Void)? {
        didSet {
            viewModel.inputs.setReminderHandler(onTimeReminderSelect: onTimeReminderSelect)
        }
    }
    
    var onShortcutSelect: ((String?, ShortcutListViewOutputs) -> Void)? {
        didSet {
            viewModel.inputs.setShortcutHandler(onShortcutSelect: onShortcutSelect)
        }
    }
    
    // MARK: View properties
    private let topMargin: CGFloat = StyleGuide.DetailTask.Sizes.topMargin
        
    private let viewOriginOnStart: CGPoint = {
        guard let globalFrame = UIView.globalView?.frame else { return CGPoint.zero }
        let origin = CGPoint(x: globalFrame.origin.x, y: globalFrame.height)

        return origin
    }()
                
    var scrollContentView: DetailTaskScrollViewType
        
    private let accessoryView: UIView = {
        let accessoryView = UIView()
        accessoryView.translatesAutoresizingMaskIntoConstraints = false
        accessoryView.backgroundColor = .white
        accessoryView.layer.borderColor = R.color.taskList.cellMainTitle()!.cgColor
        accessoryView.layer.borderWidth = StyleGuide.DetailTask.Sizes.accessoryViewBorderWidth
        
        return accessoryView
    }()
    
    private let accesoryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        return stackView
    }()
        
    private let shortcutButton: ShortcutButton = {
        let shortcutBtn = ShortcutButton()
        shortcutBtn.translatesAutoresizingMaskIntoConstraints = false
        
        return shortcutBtn
    }()
    
    private var accesoryBottomConstraint: NSLayoutConstraint = NSLayoutConstraint()
            
    private var importanceBtn: ImportanceAccessory?
    private var calendarBtn: CalendarAccessory?
    private var alarmBtn: AlarmAccessory?
    
    private let saveBtn: SaveAccessory = SaveAccessory()
    
    // MARK: Init
    init(viewModel: DetailTaskViewModelType, presenter: RouterType?, presentableControllerViewType: PresentableControllerViewType) {
        self.viewModel = viewModel
        self.router = presenter
        self.presentableControllerViewType = presentableControllerViewType
        self.scrollContentView = DetailTaskScrollView(viewModel: viewModel)
        
        super.init(nibName: nil, bundle: nil)
    
        setupNotifications()
    }
    
    deinit {
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
    
    @objc private func keyboardWillShowNotification(notification: NSNotification) {
        updateTextViewLowerLimit(notification: notification)
        updateBottomLayoutConstraintWithNotification(notification: notification, keyboardShow: true)
    }
    
    @objc private func keyboardWillHideNotification(notification: NSNotification) {
        updateTextViewLowerLimit(notification: notification)
        updateBottomLayoutConstraintWithNotification(notification: notification, keyboardShow: false)
    }
    
    private func updateTextViewLowerLimit(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            
            let lowerLimitToScroll = keyboardEndFrame.origin.y - accesoryStackView.frame.height - StyleGuide.DetailTask.Sizes.buttonsAreaHeightForScrollLimit - StyleGuide.DetailTask.Sizes.addSubtaskLabelHeight
            
            scrollContentView.limitToScroll = lowerLimitToScroll
        }
    }
    
    private func updateBottomLayoutConstraintWithNotification(notification: NSNotification, keyboardShow: Bool) {
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
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollContentView.becomeTextInputResponder()
    }
        
    // MARK: View setup
    private func setupView() {
        let globalFrame = UIView.globalSafeAreaFrame
    
        view.frame = CGRect(origin: globalFrame.origin, size: CGSize(width: globalFrame.width, height: globalFrame.height))
        view.clipsToBounds = true
        view.backgroundColor = R.color.detailTask.background()
        let mask = CAShapeLayer()
        
        let cornerRadius = StyleGuide.DetailTask.Sizes.viewCornerRadius
        mask.path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
        
        view.layer.mask = mask
                
        scrollContentView.setCloseHandler(handler: { [weak self] in
            self?.tapToCloseAction()
        })
        
        view.addSubview(scrollContentView)
                
        view.insertSubview(shortcutButton, aboveSubview: scrollContentView)
        
        shortcutButton.shortcutBtnData = viewModel.outputs.selectedShortcut.value
        
        importanceBtn = ImportanceAccessory(onTapAction: { [weak self] in
            self?.viewModel.inputs.increaseImportance()
            }, importanceLevel: viewModel.outputs.importanceLevel)
        
        calendarBtn = CalendarAccessory(onTapAction: { [weak self] in
            self?.calendarTapAction()
            }, day: nil)
        
        alarmBtn = AlarmAccessory(onTapAction: { [weak self] in
            self?.reminderTapAction()
            })
                 
        accesoryStackView.addArrangedSubview(calendarBtn!)
        accesoryStackView.addArrangedSubview(alarmBtn!)
        accesoryStackView.addArrangedSubview(importanceBtn!)
        accesoryStackView.addArrangedSubview(saveBtn)
                
        accessoryView.addSubview(accesoryStackView)

        view.insertSubview(accessoryView, at: view.subviews.count)
        
        setupConstraints()
        setupActions()
    }
        
    // MARK: Actions setup
    private func setupActions() {
        let saveBtnTap = UITapGestureRecognizer(target: self, action: #selector(saveTaskAction(sender:)))
        saveBtn.addGestureRecognizer(saveBtnTap)
        
        let selectShortcutTap = UITapGestureRecognizer(target: self, action: #selector(selectShortcutTapAction(sender:)))
        shortcutButton.addGestureRecognizer(selectShortcutTap)
    }
    
    // MARK: Constraints setup
    private func setupConstraints() {
                                
        var constraints = [
            scrollContentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollContentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollContentView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: accessoryView.topAnchor, constant: 0),
        ]
         
        accesoryBottomConstraint = accessoryView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.globalSafeAreaInsets.bottom)
        
        constraints.append(contentsOf: [
            accesoryStackView.topAnchor.constraint(equalTo: accessoryView.topAnchor),
            accesoryStackView.leadingAnchor.constraint(equalTo: accessoryView.leadingAnchor),
            accesoryStackView.trailingAnchor.constraint(equalTo: accessoryView.trailingAnchor),
            accesoryStackView.bottomAnchor.constraint(equalTo: accessoryView.bottomAnchor),
            accessoryView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            accesoryBottomConstraint,
            accessoryView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            accessoryView.heightAnchor.constraint(equalToConstant: StyleGuide.DetailTask.Sizes.accesoryStackViewHeight)
        ])
            
        let shortcutWidthConstraint = shortcutButton.widthAnchor.constraint(equalToConstant: 10)
        shortcutWidthConstraint.priority = UILayoutPriority(250)
        
        constraints.append(contentsOf: [
            shortcutButton.heightAnchor.constraint(equalToConstant: StyleGuide.getSizeRelativeToScreenWidth(baseSize: 35)),
            shortcutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            shortcutButton.bottomAnchor.constraint(equalTo: accessoryView.topAnchor, constant: -10),
            shortcutWidthConstraint
        ])
        
        NSLayoutConstraint.activate(constraints)
    }
}

// MARK: Bind viewModel
extension DetailTaskNewViewController {
    private func bindViewModel() {
        viewModel.outputs.selectedDate.bind { [weak self] date in
            guard let date = date else {
                if let calendarBtn = self?.calendarBtn {
                    calendarBtn.day = nil
                }
                return
            }
                         
            if let calendarBtn = self?.calendarBtn {
                calendarBtn.day = date
            }
        }
        
        viewModel.outputs.selectedTime.bind { [weak self] dateTime in
            guard let _ = dateTime else {
                if let alarmBtn = self?.alarmBtn {
                    alarmBtn.alarmIsSet = false
                }
                return
            }
            
            if let alarmBtn = self?.alarmBtn {
                alarmBtn.alarmIsSet = true
            }
        }
        
        viewModel.outputs.selectedShortcut.bind { [weak self] shortcutData in
            self?.shortcutButton.shortcutBtnData = shortcutData
        }
        
        viewModel.outputs.onReturnToEdit.bind { [weak self] edit in
            guard let strongSelf = self else { return }
            
            if (strongSelf.isViewLoaded && strongSelf.view.window != nil) {
                strongSelf.scrollContentView.becomeTextInputResponder()
            }
        }
        
        viewModel.outputs.addSubtaskEvent.subscribe(self) { (this, _) in
            self.scrollContentView.addNewSubtask()
        }
    }
}

// MARK: Actions
extension DetailTaskNewViewController {
    
    @objc private func subtasksAddAction(sender: UITapGestureRecognizer) {
        scrollContentView.addNewSubtask()
    }
    
    // MARK: - Accessory view actions
    @objc private func saveTaskAction(sender: UIButton) {
        if scrollContentView.currentTitle.isEmpty {
            scrollContentView.shakeTitle()
            return
        }
        
        viewModel.inputs.saveTask()
        router?.pop(vc: self)
    }
    
    private func calendarTapAction() {
        scrollContentView.resignTextInputResponders()
        viewModel.inputs.openCalendar()
    }
    
    private func reminderTapAction() {
        scrollContentView.resignTextInputResponders()
        viewModel.inputs.openReminder()
    }
    
    @objc private func selectShortcutTapAction(sender: UITapGestureRecognizer) {
        viewModel.inputs.openShortcuts()
    }
    
    // MARK: - Close actions
    
    private func tapToCloseAction() {
        router?.pop(vc: self)
    }
    
}

// MARK: UIGestureRecognizerDelegate
extension DetailTaskNewViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {

        if let panGesture = gestureRecognizer as? UIPanGestureRecognizer {
            if panGesture.velocity(in: view).y < 0 {
                return false
            }
        }

        return scrollContentView.contentOffset.y <= 0
    }
}
