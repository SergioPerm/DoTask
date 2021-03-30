//
//  SettingsViewController.swift
//  DoTask
//
//  Created by kluv on 24/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, PresentableController {
    
    var presentableControllerViewType: PresentableControllerViewType
    var router: RouterType?
    var persistentType: PersistentViewControllerType?
    
    init(presenter: RouterType?, presentableControllerViewType: PresentableControllerViewType) {
        self.router = presenter
        self.presentableControllerViewType = presentableControllerViewType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 600
        tableView.backgroundColor = .white
        tableView.sectionFooterHeight = 0
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.className)
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints({ make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        })
    }

}

extension SettingsViewController: UITableViewDelegate {
    
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.className) else {
            return UITableViewCell()
        }
        
        return cell
    }
    
}
