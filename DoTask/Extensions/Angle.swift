//
//  Angle.swift
//  DoTask
//
//  Created by kluv on 12/10/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

typealias Angle = Measurement<UnitAngle>

extension Measurement where UnitType == UnitAngle {
    init(degrees: Double) {
        self.init(value: degrees, unit: .degrees)
    }
    
    func toRadians() -> CGFloat {
        return CGFloat(converted(to: .radians).value)
    }
}
