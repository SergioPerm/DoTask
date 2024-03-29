//
//  MenuItemViewModelSelectable.swift
//  DoTask
//
//  Created by KLuV on 08.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol MenuItemViewModelSelectableType {
    var selectedItem: Observable<Bool> { get set }
}
