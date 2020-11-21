//
//  StyleGuide.swift
//  Tasker
//
//  Created by kluv on 10/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

struct StyleGuide {
    enum CalendarDatePicker {
        //ratio sizes
        static let ratioToScreenWidth: CGFloat = 0.75
        static let ratioPanelToCollection: CGFloat = 0.21
        
        //collection view
        static let cellsInterItemSpacing: CGFloat = 5.0
        static let cellPerRowCount: CGFloat = 7.0
        static let collectionMargins: CGFloat = 20.0
        
        //view
        static let viewCornerRadius: CGFloat = 8.0
        
        //colors
        static let viewBackgroundColor: UIColor = .white
        
        //animation values
        static let scaleShowAnimationValue: CGFloat = 0.95
        static let alphaShowAnimationValue: CGFloat = 0.3
    }
    
    enum TimePicker {
        //ratio sizes
        static let ratioToScreenWidth: CGFloat = 0.75
        static let ratioToScreenHeight: CGFloat = 0.5
        static let ratioPanelToViewHeight: CGFloat = 0.21
        
        //view
        static let viewCornerRadius: CGFloat = 8.0
        static let pickerRowHeightComponent: CGFloat = 100
        static let pickerWidthComponent: CGFloat = 60
        
        //colors
        static let pickerTextColor: UIColor = #colorLiteral(red: 0.2369126672, green: 0.6231006994, blue: 1, alpha: 1)
        
        //animation values
        static let scaleShowAnimationValue: CGFloat = 0.95
        static let alphaShowAnimationValue: CGFloat = 0.3
    }
}
