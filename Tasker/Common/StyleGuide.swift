//
//  StyleGuide.swift
//  Tasker
//
//  Created by kluv on 10/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

struct StyleGuide {
   
    static let baseScreenWidth: CGFloat = 375
    
    struct TaskList {
        enum Fonts {
            static let cellMainTitle: UIFont = FontFactory.Regular.of(size: StyleGuide.getFontSizeRelativeToScreen(baseSize: 15))
            static let cellAdditionalTitle: UIFont = FontFactory.Regular.of(size: StyleGuide.getFontSizeRelativeToScreen(baseSize: 12))
        }
        
        enum Sizes {
            
        }
        
        enum Colors {
            static let cellMainTitle: UIColor = #colorLiteral(red: 0.2369126672, green: 0.6231006994, blue: 1, alpha: 1)
            static let cellAdditionalTitle: UIColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
    }
    
    static func getFontSizeRelativeToScreen(baseSize: CGFloat) -> CGFloat {
        //Current runable device/simulator width find
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
                
        // "14" font size is defult font size
        let fontSize = baseSize * (width / StyleGuide.baseScreenWidth)
        
        return fontSize
    }
    
    enum DetailTask {
        
        enum Sizes {
            //view
            static let topMargin: CGFloat = 40.0
            static let viewCornerRadius: CGFloat = 16.0
            
            //Content
            static let contentSidePadding: CGFloat = 20.0
            static let chevronHeight: CGFloat = 20
            static let swipeCloseViewHeight: CGFloat = 40
            static let accesoryStackViewHeight: CGFloat = 45
        }
        
        enum Colors {
            //colors
            static let chevronTintColor: UIColor = #colorLiteral(red: 0.8901960784, green: 0.8901960784, blue: 0.8901960784, alpha: 1)
            static let viewBGColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        

    }
    
    enum CalendarDatePicker {
        //ratio sizes
        static let ratioToScreenWidth: CGFloat = 0.75
        static let ratioPanelToCollection: CGFloat = 0.21
        static let ratioToViewWidthFont: CGFloat = 0.07
        
        //collection view
        static let cellsInterItemSpacing: CGFloat = 5.0
        static let cellPerRowCount: CGFloat = 7.0
        static let collectionMargins: CGFloat = 10.0
        
        //collection view cell
        static let ratioToScreenWidthCellFont: CGFloat = 0.049
        
        //view
        static let viewCornerRadius: CGFloat = 8.0
        static let borderWidth: CGFloat = 1.0
        
        //colors
        static let viewBackgroundColor: UIColor = .white
        static let borderColor: UIColor = #colorLiteral(red: 0.8892104444, green: 0.8892104444, blue: 0.8892104444, alpha: 1)
        
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
    
    enum SlideMenu {
        //sizes
        static let leftMargin: CGFloat = 16.0

        //ratio sizes
        static let ratioToScreenExpandWidth: CGFloat = 0.5
        static let ratioToScreenOffsetToExpand: CGFloat = 0.25
        static let ratioToScreenWidthFontSizeBigTitle: CGFloat = 0.05
        static let ratioToScreenWidthFontSizeMiddleTitle: CGFloat = 0.045
        static let ratioToScreenWidthFontSizeSmallTitle: CGFloat = 0.04

        //colors
        static let viewBGColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        //frames
        static let seetingsButtonFrame: CGRect = {
            let globalSafeFrame = UIView.globalSafeAreaFrame
            return CGRect(x: 25, y: globalSafeFrame.origin.y + 10, width: 25, height: 25)
        }()
    }
}
