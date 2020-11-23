//
//  PresenterController.swift
//  Tasker
//
//  Created by kluv on 22/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

protocol PresenterController: UIViewController {
    var presentableControllers: [PresentableController?] { get set }
    
    func push(vc: PresentableController, completion: (() -> Void)?)
    func pop(vc: PresentableController)
}
