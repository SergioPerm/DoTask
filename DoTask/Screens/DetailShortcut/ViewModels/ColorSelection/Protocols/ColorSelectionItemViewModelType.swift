//
//  ColorSelectionItemViewModelType.swift
//  DoTask
//
//  Created by Сергей Лепинин on 18.03.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol ColorSelectionItemViewModelType: AnyObject {
    var inputs: ColorSelectionItemViewModelInputs { get }
    var outputs: ColorSelectionItemViewModelOutputs { get }
}
