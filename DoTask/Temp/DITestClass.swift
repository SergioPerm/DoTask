//
//  DITestClass.swift
//  DoTask
//
//  Created by Сергей Лепинин on 31.03.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

class DITestClass: NSObject {
    
    let const1 = "Hello"
    let const2 = "DI!"
    var counter: Int = 0
        
    func say() {
        print("\(const1) \(const2) count: \(counter)")
        counter += 1
    }
    
}
