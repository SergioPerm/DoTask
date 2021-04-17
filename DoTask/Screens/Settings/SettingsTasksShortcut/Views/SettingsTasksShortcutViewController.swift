//
//  SettingsTasksShortcutViewController.swift
//  DoTask
//
//  Created by Сергей Лепинин on 16.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit
import SnapKit

class SettingsTasksShortcutViewController: UIViewController, SettingsTasksShortcutViewType {

    private let viewModel: SettingsTasksShortcutViewModelType

    private let tableView: UITableView = UITableView()
        
    var presentableControllerViewType: PresentableControllerViewType
    var router: RouterType?
    var persistentType: PersistentViewControllerType?
    
    init(viewModel: SettingsTasksShortcutViewModelType, router: RouterType?, presentableControllerViewType: PresentableControllerViewType) {
        self.viewModel = viewModel
        self.router = router
        self.presentableControllerViewType = presentableControllerViewType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupConstraints()
    }
}

extension SettingsTasksShortcutViewController {
    private func setup() {        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 600
        tableView.backgroundColor = .white
        tableView.sectionFooterHeight = 0
        
        tableView.dataSource = self
        
        tableView.register(SettingsTasksShortcutTableViewCell.self, forCellReuseIdentifier: SettingsTasksShortcutTableViewCell.className)
        
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints({ make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        })
    }
}

extension SettingsTasksShortcutViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.outputs.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTasksShortcutTableViewCell.className) as? SettingsTasksShortcutTableViewCell else {
            return UITableViewCell()
        }
        
        cell.viewModel = viewModel.outputs.items[indexPath.row]
        
        return cell
    }
}

