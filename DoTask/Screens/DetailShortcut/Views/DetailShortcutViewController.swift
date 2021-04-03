//
//  DetailShortcutViewController.swift
//  DoTask
//
//  Created by KLuV on 05.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class DetailShortcutViewController: UIViewController, DetailShortcutViewType {
    
    var shortcutUID: String? {
        didSet {
            viewModel.inputs.setShortcutUID(UID: shortcutUID)
        }
    }
        
    var presentableControllerViewType: PresentableControllerViewType
    var router: RouterType?
    var persistentType: PersistentViewControllerType?
    
    // MARK: ViewModel
    private var viewModel: DetailShortcutViewModelType
    
    // MARK: View's properties
    
    private let labelView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = FontFactory.Helvetica.of(size: StyleGuide.getSizeRelativeToScreenWidth(baseSize: 20))
        
        return textField
    }()
    
    private let colorDotView: ColorDotView = ColorDotView()
    private let showInMainListView: ShowInMainListView = ShowInMainListView()
    private let saveShortcutBtn: SaveShortcutButton = SaveShortcutButton()
    private let deleteShortcutBtn: DeleteShortcutButton = DeleteShortcutButton()
    private let colorSelectionView: ColorSelectionView = ColorSelectionView()
    
    private var colorSelectionBottomConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
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
                
        labelView.addSubview(colorDotView)
        labelView.addSubview(nameTextField)
        
        nameTextField.placeholder = "New shortcut"
        
        view.addSubview(labelView)
        view.addSubview(showInMainListView)
        view.addSubview(colorSelectionView)
        view.insertSubview(saveShortcutBtn, belowSubview: colorSelectionView)
        view.insertSubview(deleteShortcutBtn, belowSubview: colorSelectionView)
        
        deleteShortcutBtn.isHidden = viewModel.outputs.isNew
        
        showInMainListView.toggleShowInMainListHandler = { [unowned self] in
            self.viewModel.inputs.toggleshowInMainListSetting()
        }
        
        nameTextField.text = viewModel.outputs.title
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
                
        let rowHeight: CGFloat = StyleGuide.DetailShortcut.Sizes.rowHeight//StyleGuide.DetailShortcut.Sizes.RatioToScreenWidth.rowHeight * globalView.frame.width
        
        var constraints = [
            colorDotView.topAnchor.constraint(equalTo: labelView.topAnchor),
            colorDotView.bottomAnchor.constraint(equalTo: labelView.bottomAnchor),
            colorDotView.widthAnchor.constraint(equalToConstant: StyleGuide.getSizeRelativeToScreenWidth(baseSize: 7)),
            colorDotView.leadingAnchor.constraint(equalTo: labelView.leadingAnchor),
            colorDotView.trailingAnchor.constraint(equalTo: nameTextField.leadingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: rowHeight),
            nameTextField.centerYAnchor.constraint(equalTo: labelView.centerYAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: labelView.trailingAnchor)
        ]
        
        constraints.append(contentsOf: [
            showInMainListView.heightAnchor.constraint(equalToConstant: rowHeight),
            showInMainListView.topAnchor.constraint(equalTo: labelView.bottomAnchor, constant: 5),
            showInMainListView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            showInMainListView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25)
        ])
        
        constraints.append(contentsOf: [
            labelView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            labelView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            labelView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            labelView.heightAnchor.constraint(equalToConstant: rowHeight)
        ])
        
        colorSelectionBottomConstraint = colorSelectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.globalSafeAreaInsets.bottom - 10)
        
        constraints.append(contentsOf: [
            colorSelectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            colorSelectionView.heightAnchor.constraint(equalToConstant: rowHeight),
            colorSelectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            colorSelectionBottomConstraint
        ])
        
        let btnWidthRatioToScreenWidth = StyleGuide.DetailShortcut.Sizes.RatioToScreenWidth.btnWidth
        
        constraints.append(contentsOf: [
            saveShortcutBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            saveShortcutBtn.bottomAnchor.constraint(equalTo: colorSelectionView.topAnchor, constant: -10),
            saveShortcutBtn.widthAnchor.constraint(equalToConstant: UIView.globalSafeAreaFrame.width * btnWidthRatioToScreenWidth),
            saveShortcutBtn.heightAnchor.constraint(equalToConstant: 30),
            deleteShortcutBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            deleteShortcutBtn.bottomAnchor.constraint(equalTo: colorSelectionView.topAnchor, constant: -10),
            deleteShortcutBtn.widthAnchor.constraint(equalToConstant: UIView.globalSafeAreaFrame.width * btnWidthRatioToScreenWidth),
            deleteShortcutBtn.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate(constraints)
    }
}

// MARK: Bind viewModel

extension DetailShortcutViewController {
    private func bindViewModel() {
        colorSelectionView.presetColors = viewModel.outputs.getAllColors()
        
        viewModel.outputs.selectedColor.bind { [weak self] colorHex in
            self?.colorDotView.currentColor = UIColor(hexString: colorHex)
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
        //let convertedKeyboardEndFrame = view.convert(keyboardEndFrame, from: view.window)
        let rawAnimationCurve = (notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).uint32Value << 16
        let animationCurve = UIView.AnimationOptions.init(rawValue: UInt(rawAnimationCurve))
                
        if keyboardShow {
            colorSelectionBottomConstraint.constant = (convertedKeyboardEndFrame.minY - viewFrame.minY) - view.bounds.maxY
        } else {
            colorSelectionBottomConstraint.constant = -view.globalSafeAreaInsets.bottom
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
        viewModel.inputs.setTitle(title: nameTextField.text!)
    }
}


