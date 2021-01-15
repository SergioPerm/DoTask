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
    var presenter: PresenterController?
    
    private let viewModel: ShortcutListViewModelType
    
    private let tableView: UITableView = UITableView()
    
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
    
    init(viewModel: ShortcutListViewModelType, presenter: PresenterController?, presentableControllerViewType: PresentableControllerViewType) {
        self.viewModel = viewModel
        self.presenter = presenter
        self.presentableControllerViewType = presentableControllerViewType
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setup()
        // Do any additional setup after loading the view.
    }
    
}

extension ShortcutListViewController {
    private func setup() {
        
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = 50
        
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(ShortcutListTableViewCell.self, forCellReuseIdentifier: ShortcutListTableViewCell.className)
        
        searchView.addSubview(searchImage)
        searchView.addSubview(searchTextField)
        
        searchTextField.placeholder = "Search shortcut"
        searchTextField.delegate = self
        
        view.addSubview(searchView)
        view.addSubview(tableView)
        
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
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ]
        
        NSLayoutConstraint.activate(constraints)
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
            presenter?.pop(vc: self)
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
