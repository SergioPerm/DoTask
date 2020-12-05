//
//  String.swift
//  Tasker
//
//  Created by kluv on 10/10/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
