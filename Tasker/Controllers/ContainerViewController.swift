//
//  ContainerViewController.swift
//  Tasker
//
//  Created by kluv on 28/09/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    var mainViewController: TaskListViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        view.backgroundColor = .clear
        
        configureMainViewConrtoller()
        // Do any additional setup after loading the view.
    }
    
    func configureMainViewConrtoller() {
        
        mainViewController = TaskListViewController(editTaskAction: { [weak self] taskID in
            if let taskID = taskID {
                self?.editTask(taskID: taskID)
            }
        })
        
        _ = UINavigationController(rootViewController: mainViewController)
        
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAction(sender:)))
        
        mainViewController.navigationItem.rightBarButtonItem = addItem
        mainViewController.title = "Tasker"
        
        self.add(mainViewController.navigationController!)
        
    }

    @objc func addAction(sender: UIBarButtonItem) {
        let detailTaskViewController = DetailTaskViewController()
        addSubviewAtIndex(detailTaskViewController, at: 1)
        //mainViewController.viewModel.addTask(from: <#T##TaskModel#>)
    }
    
    func editTask(taskID: String) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
