//
//  AnimatableProps.swift
//  DoTask
//
//  Created by KLuV on 07.03.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

protocol AnimatableProps: AnyObject {
    
    // [ViewProperty?:Snapshot]
    var animatableProps: [UIView?: UIView] { get set }
    
}

extension AnimatableProps {
    
    func addProp(prop: UIView, afterScreenUpdates: Bool) {
        animatableProps[prop] = prop.snapshotView(afterScreenUpdates: afterScreenUpdates)
    }
    
}
