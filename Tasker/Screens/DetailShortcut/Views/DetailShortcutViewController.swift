//
//  DetailShortcutViewController.swift
//  Tasker
//
//  Created by KLuV on 05.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class DetailShortcutViewController: UIViewController, PresentableController {
    
    var presentableControllerViewType: PresentableControllerViewType
    var presenter: PresenterController?
    
    // MARK: ViewModel
    private var viewModel: DetailShortcutViewModelType
    
    // MARK: View's properties
    private let placeholderLabel: UILabel = UILabel()
    
    private let labelView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    private let colorDotView: ColorDotView = ColorDotView()
    private let showInMainListView: ShowInMainListView = ShowInMainListView()
    private let saveShortcutBtn: SaveShortcutButton = SaveShortcutButton()
    private let deleteShortcutBtn: DeleteShortcutButton = DeleteShortcutButton()
    private let colorSelectionView: ColorSelectionView = ColorSelectionView()
    
    private var colorSelectionBottomConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    // MARK: Initializers
    
    init(viewModel: DetailShortcutViewModelType, presenter: PresenterController?, presentableControllerViewType: PresentableControllerViewType) {
        self.viewModel = viewModel
        self.presenter = presenter
        self.presentableControllerViewType = presentableControllerViewType
        
        super.init(nibName: nil, bundle: nil)
        
        setupNotifications()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View's life-cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupPlaceholder()
        setupConstraints()
        bindViewModel()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.pop(vc: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        placeholderLabel.frame = CGRect(x: 0, y: 5, width: nameTextField.frame.width, height: nameTextField.frame.height * 0.8)
        
        if colorSelectionView.selectedColor == nil {
            //default color
            colorSelectionView.selectedColor = viewModel.outputs.getAllColors()[3]
        }
    }
    
}

// MARK: Setup

extension DetailShortcutViewController {
    private func setup() {
        view.backgroundColor = .white
                
        labelView.addSubview(colorDotView)
        labelView.addSubview(nameTextField)
        
        view.addSubview(labelView)
        view.addSubview(showInMainListView)
        view.addSubview(colorSelectionView)
        view.insertSubview(saveShortcutBtn, belowSubview: colorSelectionView)
        view.insertSubview(deleteShortcutBtn, belowSubview: colorSelectionView)
        
        deleteShortcutBtn.isHidden = viewModel.outputs.isNew
        
        showInMainListView.toggleShowInMainListHandler = {
            self.viewModel.inputs.toggleshowInMainListSetting()
        }
        
        nameTextField.text = viewModel.outputs.title
        showInMainListView.showInMainList = viewModel.outputs.showInMainListSetting
        
        colorSelectionView.colorSelectionHandler = { color in
            if let selectColor = color {
                self.viewModel.inputs.setColor(color: selectColor)
            }
        }
        
        let saveShortcutTap = UITapGestureRecognizer(target: self, action: #selector(saveShortcutAction(sender:)))
        saveShortcutBtn.addGestureRecognizer(saveShortcutTap)
        
        let deleteShortcutTap = UITapGestureRecognizer(target: self, action: #selector(deleteShortcutAction(sender:)))
        deleteShortcutBtn.addGestureRecognizer(deleteShortcutTap)
        
        nameTextField.delegate = self
        nameTextField.becomeFirstResponder()
        
        colorSelectionView.presetColors = viewModel.outputs.getAllColors()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.colorSelectionView.selectedColor = self.viewModel.outputs.selectedColor.value
        }
    }
            
    private func setupConstraints() {
        var constraints = [
            colorDotView.topAnchor.constraint(equalTo: labelView.topAnchor),
            colorDotView.bottomAnchor.constraint(equalTo: labelView.bottomAnchor),
            colorDotView.widthAnchor.constraint(equalToConstant: 7),
            colorDotView.leadingAnchor.constraint(equalTo: labelView.leadingAnchor),
            colorDotView.trailingAnchor.constraint(equalTo: nameTextField.leadingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 50),
            nameTextField.centerYAnchor.constraint(equalTo: labelView.centerYAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: labelView.trailingAnchor)
        ]
        
        constraints.append(contentsOf: [
            showInMainListView.heightAnchor.constraint(equalToConstant: 50),
            showInMainListView.topAnchor.constraint(equalTo: labelView.bottomAnchor, constant: 5),
            showInMainListView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            showInMainListView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25)
        ])
        
        constraints.append(contentsOf: [
            labelView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            labelView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            labelView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            labelView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        colorSelectionBottomConstraint = colorSelectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.globalSafeAreaInsets.bottom - 10)
        
        constraints.append(contentsOf: [
            colorSelectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            colorSelectionView.heightAnchor.constraint(equalToConstant: 50),
            colorSelectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            colorSelectionBottomConstraint
        ])
        
        constraints.append(contentsOf: [
            saveShortcutBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            saveShortcutBtn.bottomAnchor.constraint(equalTo: colorSelectionView.topAnchor, constant: -10),
            saveShortcutBtn.widthAnchor.constraint(equalToConstant: UIView.globalSafeAreaFrame.width * 0.25),
            saveShortcutBtn.heightAnchor.constraint(equalToConstant: 30),
            deleteShortcutBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            deleteShortcutBtn.bottomAnchor.constraint(equalTo: colorSelectionView.topAnchor, constant: -10),
            deleteShortcutBtn.widthAnchor.constraint(equalToConstant: UIView.globalSafeAreaFrame.width * 0.25),
            deleteShortcutBtn.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupPlaceholder() {
        placeholderLabel.text = "New shortcut"
        placeholderLabel.sizeToFit()
        nameTextField.addSubview(placeholderLabel)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !nameTextField.text!.isEmpty
        
        placeholderLabel.frame = CGRect(x: 0, y: 5, width: UIView.globalSafeAreaFrame.width * 0.7, height: 50 * 0.8)
    }
        
}

// MARK: Bind viewModel

extension DetailShortcutViewController {
    private func bindViewModel() {
        viewModel.outputs.selectedColor.bind { color in
            guard let color = color else { return }
            self.colorDotView.currentColor = color
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
        presenter?.pop(vc: self)
    }
    
    @objc private func deleteShortcutAction(sender: UITapGestureRecognizer) {
        viewModel.inputs.delete()
        presenter?.pop(vc: self)
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
        
        let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let keyboardEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let convertedKeyboardEndFrame = view.convert(keyboardEndFrame, from: view.window)
        let rawAnimationCurve = (notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).uint32Value << 16
        let animationCurve = UIView.AnimationOptions.init(rawValue: UInt(rawAnimationCurve))
                
        if keyboardShow {
            colorSelectionBottomConstraint.constant = convertedKeyboardEndFrame.minY - view.bounds.maxY
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
    func textFieldDidChangeSelection(_ textField: UITextField) {
        placeholderLabel.isHidden = !textField.text!.isEmpty
        viewModel.inputs.setTitle(title: textField.text!)
    }
}
