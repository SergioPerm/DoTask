//
//  LeftMenuViewController.swift
//  Tasker
//
//  Created by kluv on 26/10/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

class LeftMenuViewController: UIViewController {

    private var testTapHandler: (() -> Void)?
    
    init(testTap: @escaping () -> Void) {
        self.testTapHandler = testTap
        super.init(nibName: nil, bundle: nil)
        _ = UINavigationController(rootViewController: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.green
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(testAction(sender:)))
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("disappear")
    }


}

extension LeftMenuViewController {
    @objc func testAction(sender: UIBarButtonItem) {
        guard let testTapHandler = testTapHandler else { return }
        testTapHandler()
    }
}
