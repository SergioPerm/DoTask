//
//  DetailShortcutViewModel.swift
//  Tasker
//
//  Created by KLuV on 05.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class DetailShortcutViewModel: DetailShortcutViewModelType, DetailShortcutViewModelInputs, DetailShortcutViewModelOutputs {
    
    private var shortcut: Shortcut
    private var dataSource: ShortcutListDataSource

    private var presetColors: [UIColor] = [
        #colorLiteral(red: 0.9019607843, green: 0.09803921569, blue: 0.2941176471, alpha: 1), #colorLiteral(red: 0.2352941176, green: 0.7058823529, blue: 0.2941176471, alpha: 1), #colorLiteral(red: 1, green: 0.8823529412, blue: 0.09803921569, alpha: 1), #colorLiteral(red: 0.262745098, green: 0.3882352941, blue: 0.8470588235, alpha: 1), #colorLiteral(red: 0.9607843137, green: 0.5098039216, blue: 0.1921568627, alpha: 1), #colorLiteral(red: 0.568627451, green: 0.1176470588, blue: 0.7058823529, alpha: 1), #colorLiteral(red: 0.2588235294, green: 0.831372549, blue: 0.9568627451, alpha: 1), #colorLiteral(red: 0.9411764706, green: 0.1960784314, blue: 0.9019607843, alpha: 1), #colorLiteral(red: 0.7490196078, green: 0.937254902, blue: 0.2705882353, alpha: 1), #colorLiteral(red: 0.9803921569, green: 0.7450980392, blue: 0.831372549, alpha: 1), #colorLiteral(red: 0.2745098039, green: 0.6, blue: 0.5647058824, alpha: 1), #colorLiteral(red: 0.862745098, green: 0.7450980392, blue: 1, alpha: 1), #colorLiteral(red: 0.6039215686, green: 0.3882352941, blue: 0.1411764706, alpha: 1), #colorLiteral(red: 1, green: 0.9803921569, blue: 0.7843137255, alpha: 1), #colorLiteral(red: 0.5019607843, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0.6666666667, green: 1, blue: 0.7647058824, alpha: 1), #colorLiteral(red: 0.5019607843, green: 0.5019607843, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.8470588235, blue: 0.6941176471, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0.4588235294, alpha: 1), #colorLiteral(red: 0.662745098, green: 0.662745098, blue: 0.662745098, alpha: 1)
    ]
    
    var inputs: DetailShortcutViewModelInputs { return self }
    var outputs: DetailShortcutViewModelOutputs { return self }

    init(shortcutUID: String?, dataSource: ShortcutListDataSource) {
        self.shortcut = dataSource.shortcutByIdentifier(identifier: shortcutUID) ?? Shortcut()
        self.dataSource = dataSource
        
        
        self.selectedColor = Boxing(UIColor(hexString: shortcut.color))
        self.title = shortcut.name
        
        if shortcutUID == nil {
            self.selectedColor.value = presetColors[3]
            setColor(color: presetColors[3])
        }
    }
    
    // MARK: Inputs
    
    func setColor(color: UIColor) {
        shortcut.color = color.toHexString()
        selectedColor.value = color
    }

    func setTitle(title: String) {
        shortcut.name = title
    }

    func toggleshowInMainListSetting() {
        shortcut.showInMainList = !shortcut.showInMainList
    }
    
    func save() {
        if shortcut.isNew {
            dataSource.addShortcut(for: shortcut)
        } else {
            dataSource.updateShortcut(for: shortcut)
        }
    }
    
    func delete() {
        if !shortcut.isNew {
            dataSource.deleteShortcut(for: shortcut)
        }
    }

    // MARK: OUTPUTS
    
    var selectedColor: Boxing<UIColor?>
    var title: String
    var showInMainListSetting: Bool {
        return shortcut.showInMainList
    }
    
    func getAllColors() -> [UIColor] {
        return presetColors
    }
    
    var isNew: Bool {
        return shortcut.isNew
    }
}
