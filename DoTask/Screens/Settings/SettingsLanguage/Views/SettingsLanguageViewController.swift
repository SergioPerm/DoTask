//
//  SettingsLanguageViewController.swift
//  DoTask
//
//  Created by Сергей Лепинин on 06.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class SettingsLanguageViewController: UIViewController, PresentableController {
    
    private let viewModel: SettingsLanguageViewModelType
    
    var presentableControllerViewType: PresentableControllerViewType
    var router: RouterType?
    var persistentType: PersistentViewControllerType?
    
    init(viewModel: SettingsLanguageViewModelType, router: RouterType?, presentableControllerViewType: PresentableControllerViewType) {
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

        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 600
        tableView.backgroundColor = .white
        tableView.sectionFooterHeight = 0
        
        tableView.dataSource = self
        
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.className)
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints({ make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        })
        
        guard let navBar = self.navigationController?.navigationBar else { return }
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44)))]
        
        let navBarTitleFrame = CGRect(x: 0, y: 0, width: UIView.globalSafeAreaFrame.width * 0.4, height: navBar.frame.height)
        let settingsNavBarTitleView = SettingsNavBarTitle(frame: navBarTitleFrame)
        navigationItem.titleView = settingsNavBarTitleView
    }
    
}

extension SettingsLanguageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
