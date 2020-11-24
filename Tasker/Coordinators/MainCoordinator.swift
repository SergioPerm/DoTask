//
//  MainCoordinator.swift
//  Tasker
//
//  Created by kluv on 22/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

class MainCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    var presenter: PresenterController?
    
    init(presenter: PresenterController) {
        self.presenter = presenter
    }
    
    func start() {
        let vc = TaskListAssembly.createInstance(presenter: presenter)
        vc.editTaskAction = { uid in
            self.editTask(taskUID: uid)
        }
        vc.openSettingsAction = {
            self.openSettings()
        }
        presenter?.push(vc: vc, completion: { [weak self] in
            self?.parentCoordinator?.childDidFinish(self)
        })
    }
            
    func openSettings() {
        let vc = SettingsAssembly.createInstance(presenter: presenter)
        presenter?.push(vc: vc, completion: { [weak self] in
            self?.parentCoordinator?.childDidFinish(self)
        })
    }
    
    func editTask(taskUID: String?) {
        let child = DetailTaskCoordinator(presenter: presenter, taskUID: taskUID)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }
}
