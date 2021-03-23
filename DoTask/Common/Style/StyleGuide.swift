//
//  StyleGuide.swift
//  DoTask
//
//  Created by kluv on 10/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

struct StyleGuide {
   
    static let baseScreenWidth: CGFloat = 375
    
    enum MainColors {
        static let blue: UIColor = #colorLiteral(red: 0.2369126672, green: 0.6231006994, blue: 1, alpha: 1)
        static let pink: UIColor = #colorLiteral(red: 1, green: 0.2117647059, blue: 0.6509803922, alpha: 0.8470588235)
    }
    
    struct CommonViews {
        struct CheckTask {
            enum Sizes {
                static let borderWidth: CGFloat = 2.5
                static let cornerRadius: CGFloat = 4
            }
        }
        
        struct MainCell {
            enum Sizes {
                static let cornerRadius: CGFloat = 8.0
                static let shadowRadius: CGFloat = 3.0
                static let shadowOffset: CGSize = CGSize(width: 0, height: 3)
                static let importanceCornerRadius: CGFloat = 10
            }
            enum Appearance {
                static let shadowOpacity: Float = 0.3
            }
        }
    }
    
    struct TaskList {
        enum Fonts {
            static let cellMainTitle: UIFont = FontFactory.AvenirNextMedium.of(size: StyleGuide.getSizeRelativeToScreenWidth(baseSize: 17))
            static let cellAdditionalTitle: UIFont = FontFactory.AvenirNextMedium.of(size: StyleGuide.getSizeRelativeToScreenWidth(baseSize: 12))
        }
        
        enum Sizes {
            static let headerHeight: CGFloat = 40.0
            static let headerTitleHeight: CGFloat = 30.0
            static let checkMarkSize: CGSize = CGSize(width: 24, height: 24)
            static let checkMarkLineWidth: CGFloat = 4.0
            
            static let capRowHeightMain: Int = 110
            static let capRowHeightCalendar: Int = 70
            static let capRowHeightLittle: Int = 5
        }
        
        enum Colors {
            static let cellMainTitle: UIColor = #colorLiteral(red: 0.2369126672, green: 0.6231006994, blue: 1, alpha: 1)
            static let cellAdditionalTitle: UIColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
        
        struct Calendar {
            enum Sizes {
                static let currentDayLayerLineWidth: CGFloat = 4.0
                static let dayWithDoneTasksLayerLineWidth: CGFloat = 2.5
            }
        }
        
        struct NavBar {
            struct Sizes {
                static let insetImageNavBarBtn: CGFloat = 9.0
                static let shortcutColorDotLineWidth: CGFloat = 1.0
                
                enum RatioToScreenWidth {
                    static let navBarTitleWidth: CGFloat = 0.7
                }
                
                enum RatioToParentFrame {
                    static let shortcutColorDotRadius: CGFloat = 0.4
                }
            }
        }
    }
    
    struct ShortcutList {
        struct Sizes {
            static let tableRowHeight: CGFloat = 50
        }
    }
    
    struct DetailShortcut {
        struct Sizes {
            enum RatioToScrennHeight {
                static let topMargin: CGFloat = 0.1
            }
            
            enum RatioToScreenWidth {
                static let btnWidth: CGFloat = 0.25
            }
        }
        
        struct ColorSelectionView {
            enum Sizes {
                static let collectionViewLayoutSectionInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
                static let collectionViewLayoutMinLineSpacing: CGFloat = 0.0
                static let topBorderHeight: CGFloat = 1.0
                static let collectionCellSize: CGSize = CGSize(width: 50, height: 50)
            }
        }
        
        struct ColorCollectionViewCell {
            enum Sizes {
                static let colorCircleLineWidth: CGFloat = 1.0
                static let colorCircleSelectLineWidth: CGFloat = 2.0
            }
        }
        
        struct ColorDotView {
            enum Sizes {
                static let lineWidth: CGFloat = 1.0
            }
        }
        
        struct ShowInMainList {
            enum Sizes {
                static let borderHeight: CGFloat = 1.0
            }
        }
        
        struct SaveBtn {
            enum Sizes {
                static let cornerRadiud: CGFloat = 15.0
            }
        }
        
        struct DeleteBtn {
            enum Sizes {
                static let cornerRadius: CGFloat = 15.0
            }
        }
    }
    
    struct SpeechTask {
        struct Sizes {
            enum RatioToScreenWidth {
                static let speakWaveWidth: CGFloat = 0.7
                static let speechTextWidth: CGFloat = 0.98
                static let letftWidthClose: CGFloat = 0.4
                static let closeZoneToSwipe: CGFloat = 0.4
            }
        }
        
        struct SpeakWave {
            struct Sizes {
                enum Scale {
                    static let zoomLayerXYStartScale: CGFloat = 0.7
                    static let gradientLayerXYStartScale: CGFloat = 0.5
                }
                
                enum Ratio {
                    static let micWidthRatioToGradient: CGFloat = 0.5
                }
            }
            
            enum Colors {
                static let gradientColor1: UIColor = #colorLiteral(red: 1, green: 0.7027073819, blue: 0.9019589665, alpha: 1)
                static let gradientColor2: UIColor = #colorLiteral(red: 1, green: 0.2117647059, blue: 0.6509803922, alpha: 1)
                static let zoomLayerColor: UIColor = #colorLiteral(red: 1, green: 0.8026864087, blue: 0.9260444804, alpha: 1)
            }
        }
        
        struct SpeachText {
            enum Colors {
                static let textColor: UIColor = .white
                static let backgroundColor: UIColor = .clear
            }
        }
        
        struct SpeechSwipe {
            struct Sizes {
                enum Ratio {
                    static let arrowImageSideSize: CGFloat = 0.05
                }
            }
        }
    }
    
    static func getSizeRelativeToScreenWidth(baseSize: CGFloat, maxSize: CGFloat? = nil) -> CGFloat {
        //Current runable device/simulator width find
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
                
        let size = baseSize * (width / StyleGuide.baseScreenWidth)
        
        if let maxSize = maxSize {
            if size > maxSize {
                return maxSize
            }
        }
        
        return size
    }
        
    enum DetailTask {
        
        struct Sizes {
            //view
            static let topMargin: CGFloat = 40.0
            static let viewCornerRadius: CGFloat = 16.0
            
            //Content
            static let contentSidePadding: CGFloat = 20.0
            static let chevronHeight: CGFloat = getSizeRelativeToScreenWidth(baseSize: 25)//25
            static let swipeCloseViewHeight: CGFloat = 40
            static let accesoryStackViewHeight: CGFloat = 45
            
            static let infoSectionHeaderHeight: Double = 2
            
            static let tableViewEstimatedHeight: CGFloat = getSizeRelativeToScreenWidth(baseSize: 38, maxSize: 40)
            
            static let accessoryViewBorderWidth: CGFloat = 1.0
            static let buttonsAreaHeightForScrollLimit: CGFloat = 50.0
            
            static let deleteBtnImageInsets: UIEdgeInsets = UIEdgeInsets(top: 12, left: 5, bottom: 12, right: 25)
                      
            static let accessoryCornerRadius: CGFloat = 6
            static let addSubtaskBtnCornerRadius: CGFloat = 10.0
            static let shortcutSelectCornerRadius: CGFloat = 14.0
            
            static let shortcutBtnLineWidth: CGFloat = 2.0
            
            enum ratioToFrameWidth {
                static let reorderControlWidth: CGFloat = 0.6
                static let checkCircleHeight: CGFloat = 0.6
            }
            
            enum ratioToScreenWidth {
                static let hideKeyboardWidth: CGFloat = 0.2
                static let addSubtaskWidth: CGFloat = 0.4
            }
        }
        
        enum Colors {
            //colors
            static let addSubtaskbtnColor: UIColor = #colorLiteral(red: 0.3027490342, green: 0.7100013522, blue: 1, alpha: 1)
            static let chevronTintColor: UIColor = #colorLiteral(red: 0.8901960784, green: 0.8901960784, blue: 0.8901960784, alpha: 1)
            static let viewBGColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        

    }
    
    enum CalendarDatePicker {
        //ratio sizes
        static let ratioToScreenWidth: CGFloat = 0.85
        static let ratioPanelToCollection: CGFloat = 0.21
        static let ratioToViewWidthFont: CGFloat = 0.065
        
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
    
    struct SlideMenu {
        
        struct Sizes {
            static let bigRowHeight: Double = 50
            static let midRowHeight: Double = 40
            
            static let leftMargin: CGFloat = 16.0
            
            static let mainSectioHeaderHeight: Double = 30.0
            
            enum RatioToScreenWidth {
                static let ratioToScreenExpandWidth: CGFloat = 0.5
                static let ratioToScreenOffsetToExpand: CGFloat = 0.25
                static let ratioToScreenWidthFontSizeBigTitle: CGFloat = 0.05
                static let ratioToScreenWidthFontSizeMiddleTitle: CGFloat = 0.045
                static let ratioToScreenWidthFontSizeSmallTitle: CGFloat = 0.04
            }
        }

        struct CreateShortcut {
            enum Sizes {
                static let createBtnImgInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
            }
        }
        
        struct ShortcutItem {
            enum Sizes {
                static let cornerRadius: CGFloat = 5.0
            }
        }
        
        //colors
        static let viewBGColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        //frames
        static let seetingsButtonFrame: CGRect = {
            let globalSafeFrame = UIView.globalSafeAreaFrame
            return CGRect(x: 25, y: globalSafeFrame.origin.y + 10, width: 25, height: 25)
        }()
    }
}
