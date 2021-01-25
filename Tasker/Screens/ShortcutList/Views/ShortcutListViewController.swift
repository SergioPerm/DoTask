//
//  ShortcutListViewController.swift
//  Tasker
//
//  Created by KLuV on 12.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class ShortcutListViewController: UIViewController, PresentableController, ShortcutListViewType {
    
    var selectShortcutHandler: ((String) -> Void)?
    
    var presentableControllerViewType: PresentableControllerViewType
    var router: RouterType?
    var persistentType: PersistentViewControllerType?
    
    private let viewModel: ShortcutListViewModelType
        
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.bounces = false
        tableView.separatorStyle = .none
        tableView.rowHeight = 50
        
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private var tableBottomConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    private let searchView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
            
        return view
    }()
    
    private let searchImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "search"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    init(viewModel: ShortcutListViewModelType, presenter: RouterType?, presentableControllerViewType: PresentableControllerViewType) {
        self.viewModel = viewModel
        self.router = presenter
        self.presentableControllerViewType = presentableControllerViewType
        
        super.init(nibName: nil, bundle: nil)
        setupNotifications()
        //transitioningDelegate = transitionController
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        deleteNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

extension ShortcutListViewController {
    private func setup() {
        
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(ShortcutListTableViewCell.self, forCellReuseIdentifier: ShortcutListTableViewCell.className)
        
        searchView.addSubview(searchImage)
        searchView.addSubview(searchTextField)
        
        searchTextField.placeholder = "Search shortcut"
        searchTextField.delegate = self
        
        view.addSubview(searchView)
        view.addSubview(tableView)
        
        tableBottomConstraint = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        
        let constraints = [
            searchImage.leadingAnchor.constraint(equalTo: searchView.leadingAnchor),
            searchImage.widthAnchor.constraint(equalToConstant: 50),
            searchImage.heightAnchor.constraint(equalToConstant: 15),
            searchImage.centerYAnchor.constraint(equalTo: searchView.centerYAnchor),
            searchImage.trailingAnchor.constraint(equalTo: searchTextField.leadingAnchor),
            searchTextField.heightAnchor.constraint(equalToConstant: 33),
            searchTextField.centerYAnchor.constraint(equalTo: searchView.centerYAnchor),
            searchTextField.trailingAnchor.constraint(equalTo: searchView.trailingAnchor),
            searchView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            searchView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchView.heightAnchor.constraint(equalToConstant: 33),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableBottomConstraint
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}

// MARK: Notifications

extension ShortcutListViewController {
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
            tableBottomConstraint.constant = convertedKeyboardEndFrame.minY - view.bounds.maxY
        } else {
            tableBottomConstraint.constant = -view.globalSafeAreaInsets.bottom
        }
                
        UIView.animate(withDuration: animationDuration,
                       delay: 0.0,
                       options: [.beginFromCurrentState, animationCurve],
                       animations: {
                        self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

extension ShortcutListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputs.shortcuts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ShortcutListTableViewCell.className, for: indexPath) as! ShortcutListTableViewCell
        
        cell.viewModel = viewModel.outputs.shortcuts[indexPath.row]
        
        return cell
    }
}

extension ShortcutListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ShortcutListTableViewCell else { return }
        guard let cellViewModel = cell.viewModel else { return }
        
        if let selectShortcutAction = selectShortcutHandler {
            selectShortcutAction(cellViewModel.outputs.uid)
            router?.pop(vc: self)
        }
    }
}

extension ShortcutListViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let searchText = searchTextField.text {
            viewModel.inputs.setFilter(shortcutNameFilter: searchText)
            tableView.reloadData()
        }
    }
}
