//
//  OnboardingPageViewModel.swift
//  DoTask
//
//  Created by Sergio Lechini on 14.06.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol OnBoardingScreenType { }

protocol OnboardingStartViewModelInputs {

}

protocol OnboardingStartViewModelOutputs {
    var lottieAnimationName: String { get }
    var mainText: LocalizableStringResource { get }
}

protocol OnboardingStartViewModelType: AnyObject {
    var inputs: OnboardingStartViewModelInputs { get }
    var outputs: OnboardingStartViewModelOutputs { get }
}

final class OnboardingStartViewModel: OnboardingStartViewModelType, OnboardingStartViewModelInputs, OnboardingStartViewModelOutputs, OnBoardingScreenType {
    
    var inputs: OnboardingStartViewModelInputs { return self }
    var outputs: OnboardingStartViewModelOutputs { return self }
        
    init(lottieAnimationName: String, mainText: LocalizableStringResource) {
        self.lottieAnimationName = lottieAnimationName
        self.mainText = mainText
    }
    
    // MARK: Inputs
    

    
    // MARK: Outputs
    
    var lottieAnimationName: String
    var mainText: LocalizableStringResource
}
