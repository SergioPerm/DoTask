//
//  DetailShortcutViewController.swift
//  DoTask
//
//  Created by KLuV on 05.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit
import SnapKit

class DetailShortcutViewController: UIViewController, DetailShortcutViewType {
    
    var openMainTaskListHandler: (() -> ())?  {
        didSet {
            viewModel.inputs.setOpenMainTaskListHandler(handler: openMainTaskListHandler)
        }
    }
    
    var shortcutUID: String? {
        didSet {
            viewModel.inputs.setShortcutUID(UID: shortcutUID)
        }
    }
        
    var presentableControllerViewType: PresentableControllerViewType
    var router: RouterType?
    var persistentType: PersistentViewControllerType?
    
    // MARK: - ViewModel
    private var viewModel: DetailShortcutViewModelType
    
    
    // MARK: - View's properties
    private let labelView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = FontFactory.AvenirNextMedium.of(size: StyleGuide.getSizeRelativeToScreenWidth(baseSize: 23))
        
        return textField
    }()
    
    private let placeholderLabel: LocalizableLabel = {
        let label = LocalizableLabel()
        label.font = FontFactory.AvenirNextMedium.of(size: StyleGuide.getSizeRelativeToScreenWidth(baseSize: 23))
        label.textColor = R.color.shortcutDetail.placeholder()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let tasksCounterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = FontFactory.HelveticaNeue.of(size: StyleGuide.getSizeRelativeToScreenWidth(baseSize: 16))
        label.textColor = R.color.shortcutDetail.taskCounterText()
        
        return label
    }()
    
    private let colorDotView: ColorDotView = ColorDotView()
    private let showInMainListView: ShowInMainListView = ShowInMainListView()
    private let saveShortcutBtn: SaveShortcutButton = SaveShortcutButton()
    private let deleteShortcutBtn: DeleteShortcutButton = DeleteShortcutButton()
    private let colorSelectionView: ColorSelectionView = ColorSelectionView()
    
    private var colorSelectionBottomConstraint: Constraint?
    private var viewFrame: CGRect = .zero
    
    // MARK: Initializers
    
    init(viewModel: DetailShortcutViewModelType, router: RouterType?, presentableControllerViewType: PresentableControllerViewType) {
        self.viewModel = viewModel
        self.router = router
        self.presentableControllerViewType = presentableControllerViewType
        
        super.init(nibName: nil, bundle: nil)
        
        setupNotifications()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deleteNotifications()
    }
    
    // MARK: View's life-cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupConstraints()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameTextField.becomeFirstResponder()
        viewModel.inputs.updateTasksCounter()
        viewModel.inputs.setDefaultColor()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        colorSelectionView.scrollToSelected()
    }
    
}

// MARK: Setup

extension DetailShortcutViewController {
    private func setup() {
        
        guard let globalView = UIView.globalView else { return }
        
        let topMargin = globalView.frame.height * StyleGuide.DetailShortcut.Sizes.RatioToScreenHeight.topMargin
        viewFrame = CGRect(x: 0, y: topMargin, width: globalView.frame.width, height: globalView.frame.height - topMargin)
        view.frame = viewFrame
        
        view.backgroundColor = .white
                
        nameTextField.addSubview(placeholderLabel)
        
        labelView.addSubview(colorDotView)
        labelView.addSubview(nameTextField)
        
        placeholderLabel.localizableString = LocalizableStringResource(stringResource: R.string.localizable.new_TITLE_SHORTCUT)
        
        view.addSubview(labelView)
        view.addSubview(showInMainListView)
        view.addSubview(colorSelectionView)
        view.insertSubview(saveShortcutBtn, belowSubview: colorSelectionView)
        view.insertSubview(deleteShortcutBtn, belowSubview: colorSelectionView)
        view.addSubview(tasksCounterLabel)
        
        deleteShortcutBtn.isHidden = viewModel.outputs.isNew
        
        showInMainListView.toggleShowInMainListHandler = { [unowned self] in
            self.viewModel.inputs.toggleshowInMainListSetting()
        }
        
        nameTextField.addTarget(self, action: #selector(textFieldEditAction(sender:)), for: .editingChanged)
        
        showInMainListView.showInMainList = viewModel.outputs.showInMainListSetting
        
        colorSelectionView.colorSelectionHandler = { [weak self] colorHex in
            self?.viewModel.inputs.setColor(colorHex: colorHex)
        }
        
        let saveShortcutTap = UITapGestureRecognizer(target: self, action: #selector(saveShortcutAction(sender:)))
        saveShortcutBtn.addGestureRecognizer(saveShortcutTap)
        
        let deleteShortcutTap = UITapGestureRecognizer(target: self, action: #selector(deleteShortcutAction(sender:)))
        deleteShortcutBtn.addGestureRecognizer(deleteShortcutTap)
        
        nameTextField.delegate = self
        
        colorSelectionView.presetColors = viewModel.outputs.getAllColors()
    }
            
    private func setupConstraints() {
                
        let rowHeight: CGFloat = StyleGuide.DetailShortcut.Sizes.rowHeight
        let colorBarHeight: CGFloat = StyleGuide.DetailShortcut.Sizes.colorSelectionBarHeight
        
        colorDotView.snp.makeConstraints({ make in
            make.top.bottom.leading.equalToSuperview()
            make.width.equalTo(StyleGuide.getSizeRelativeToScreenWidth(baseSize: 7))
            make.right.equalTo(nameTextField.snp.left).offset(-20)
        })
        
        nameTextField.snp.makeConstraints({ make in
            make.height.equalTo(rowHeight)
            make.centerY.right.equalToSuperview()
        })
        
        placeholderLabel.snp.makeConstraints({ make in
            make.centerY.equalTo(nameTextField.snp.centerY)
            make.height.equalToSuperview().multipliedBy(0.8)
            make.left.right.equalToSuperview()
        })
        
        showInMainListView.snp.makeConstraints({ make in
            make.height.equalTo(rowHeight)
            make.top.equalTo(labelView.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
        })
        
        tasksCounterLabel.snp.makeConstraints({ make in
            make.top.equalTo(showInMainListView.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
            make.height.equalTo(rowHeight)
        })
        
        labelView.snp.makeConstraints({ make in
            make.height.equalTo(rowHeight)
            make.top.equalToSuperview().offset(30)
            make.left.equalToSuperview().offset(25)
            make.right.equalToSuperview().offset(-25)
        })
        
        colorSelectionView.snp.makeConstraints({ make in
            self.colorSelectionBottomConstraint = make.bottom.equalTo(view.snp.bottom)
                .offset(-view.globalSafeAreaInsets.bottom - 10)
                .constraint
            
            make.height.equalTo(colorBarHeight)
            make.left.right.equalToSuperview()
        })
                
        let btnWidthRatioToScreenWidth = StyleGuide.DetailShortcut.Sizes.RatioToScreenWidth.btnWidth
        
        saveShortcutBtn.snp.makeConstraints({ make in
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalTo(colorSelectionView.snp.top).offset(-10)
            make.width.equalTo(UIView.globalSafeAreaFrame.width * btnWidthRatioToScreenWidth)
            make.height.equalTo(30)
        })
        
        deleteShortcutBtn.snp.makeConstraints({ make in
            make.left.equalToSuperview().offset(10)
            make.bottom.equalTo(colorSelectionView.snp.top).offset(-10)
            make.width.equalTo(UIView.globalSafeAreaFrame.width * btnWidthRatioToScreenWidth)
            make.height.equalTo(30)
        })
        
    }
}

// MARK: Bind viewModel

extension DetailShortcutViewController {
    private func bindViewModel() {
        nameTextField.text = viewModel.outputs.title
        placeholderLabel.isHidden = !viewModel.outputs.title.isEmpty
        
        colorSelectionView.presetColors = viewModel.outputs.getAllColors()
        
        viewModel.outputs.selectedColor.bind { [weak self] colorHex in
            self?.colorDotView.currentColor = UIColor(hexString: colorHex)
        }
        
        viewModel.outputs.countOfTasksEvent.subscribe(self) { this, tasksCountString in
            this.tasksCounterLabel.text = tasksCountString
        }
    }
}

// MARK: Actions

extension DetailShortcutViewController {
    @objc private func saveShortcutAction(sender: UITapGestureRecognizer) {
        if nameTextField.text == "" {
            nameTextField.shake(duration: 1)
            return
        }
        viewModel.inputs.save()
        router?.pop(vc: self)
    }
    
    @objc private func deleteShortcutAction(sender: UITapGestureRecognizer) {
        viewModel.inputs.delete()
        router?.pop(vc: self)
    }
}

// MARK: Notifications

extension DetailShortcutViewController {
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func deleteNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShowNotification(notification: NSNotification) {
        updateBottomLayoutConstraintWithNotification(notification: notification, keyboardShow: true)
    }
    
    @objc private func keyboardWillHideNotification(notification: NSNotification) {
        updateBottomLayoutConstraintWithNotification(notification: notification, keyboardShow: false)
    }
    
    private func updateBottomLayoutConstraintWithNotification(notification: NSNotification, keyboardShow: Bool) {
                
        let userInfo = notification.userInfo!
        
        guard let globalView = UIView.globalView else { return }
        
        let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let keyboardEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let convertedKeyboardEndFrame = globalView.convert(keyboardEndFrame, from: globalView.window)

        let rawAnimationCurve = (notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).uint32Value << 16
        let animationCurve = UIView.AnimationOptions.init(rawValue: UInt(rawAnimationCurve))
                
        if keyboardShow {
            colorSelectionBottomConstraint?.update(offset: (convertedKeyboardEndFrame.minY - viewFrame.minY) - view.bounds.maxY)
        } else {
            colorSelectionBottomConstraint?.update(offset: -view.globalSafeAreaInsets.bottom)
        }
                
        UIView.animate(withDuration: animationDuration,
                       delay: 0.0,
                       options: [.beginFromCurrentState, animationCurve],
                       animations: {
                        self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
}

// MARK: UITextFieldDelegate

extension DetailShortcutViewController: UITextFieldDelegate {
    @objc private func textFieldEditAction(sender: Any?) {
        placeholderLabel.isHidden = !nameTextField.text!.isEmpty
        viewModel.inputs.setTitle(title: nameTextField.text!)
    }
}


