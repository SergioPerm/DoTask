//
//  SettingsViewController.swift
//  Tasker
//
//  Created by kluv on 24/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, PresentableController {
    
    var presentableControllerViewType: PresentableControllerViewType
    var router: RouterType?
    
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

        view.backgroundColor = UIColor.purple
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
