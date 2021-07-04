//
//  OnBoardingScreenFactory.swift
//  DoTask
//
//  Created by Sergio Lechini on 14.06.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

protocol OnBoardingScreenFactoryType {
    func generateScreen(viewModel: OnBoardingScreenType) -> UIView
}

final class OnBoardingScreenFactory: OnBoardingScreenFactoryType {
    func generateScreen(viewModel: OnBoardingScreenType) -> UIView {
        switch viewModel {
        case let viewModel as OnboardingStartViewModelType:
            let view = OnBoardingStartView()
            view.viewModel = viewModel
            
            return view
        case let viewModel as OnBoardingNotifyViewModelType:
            let view = OnBoardingNotifyView()
            view.viewModel = viewModel
            
            return view
        case let viewModel as OnBoardingSpeechViewModelType:
            let view = OnBoardingSpeechView()
            view.viewModel = viewModel
            
            return view
        default:
            return UIView()
        }
        
    }
}
