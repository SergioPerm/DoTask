//
//  ColorSelectionItemViewModel.swift
//  DoTask
//
//  Created by Сергей Лепинин on 18.03.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

class ColorSelectionItemViewModel: ColorSelectionItemViewModelType, ColorSelectionItemViewModelInputs, ColorSelectionItemViewModelOutputs {
        
    var inputs: ColorSelectionItemViewModelInputs { return self }
    var outputs: ColorSelectionItemViewModelOutputs { return self }
    
    init(hexColor: String) {
        self.colorHex = hexColor
        self.selectEvent = Event<Bool>()
        self.select = false
    }
    
    // MARK: Inputs
    
    func setSelected(selected: Bool) {
        select = selected
        selectEvent.raise(selected)
    }
    
    // MARK: Outputs
    
    var selectEvent: Event<Bool>
    var select: Bool
    var colorHex: String
}
