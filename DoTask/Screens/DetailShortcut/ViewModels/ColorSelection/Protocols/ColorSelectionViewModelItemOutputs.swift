//
//  ColorSelectionViewModelItemOutputs.swift
//  DoTask
//
//  Created by Сергей Лепинин on 18.03.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol ColorSelectionItemViewModelOutputs {
    var selectEvent: Event<Bool> { get }
    var select: Bool { get }
    var colorHex: String { get }
}
