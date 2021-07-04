//
//  OnboardingViewModel.swift
//  DoTask
//
//  Created by Sergio Lechini on 13.06.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol OnBoardingViewModelInputs {
    func setNotifyPermissionDontAllowHandler(handler: (() -> ())?)
    func setSpeechPermissionDontAllowHandler(handler: (() -> ())?)
}

protocol OnBoardingViewModelOutputs {
    var pages: [OnBoardingScreenType] { get }
}

protocol OnboardingViewModelType {
    var inputs: OnBoardingViewModelInputs { get }
    var outputs: OnBoardingViewModelOutputs { get }
}

class OnBoardingViewModel: OnboardingViewModelType, OnBoardingViewModelInputs, OnBoardingViewModelOutputs, OnBoardingScreenType {
    
    private var onDoNotAllowNotify: (()->())?
    private var onDoNotAllowSpeech: (()->())?
    
    var inputs: OnBoardingViewModelInputs { return self }
    var outputs: OnBoardingViewModelOutputs { return self }
    
    init() {
        setup()
    }
    
    // MARK: Inputs
    
    func setNotifyPermissionDontAllowHandler(handler: (() -> ())?) {
        onDoNotAllowNotify = handler
    }
    
    func setSpeechPermissionDontAllowHandler(handler: (() -> ())?) {
        onDoNotAllowSpeech = handler
    }
    
    // MARK: Outputs
    
    var pages: [OnBoardingScreenType] = []
    
}

private extension OnBoardingViewModel {
    func setup() {
                
        pages.append(OnboardingStartViewModel(lottieAnimationName: "Schedule", mainText: LocalizableStringResource(stringResource: R.string.localizable.onboarding_START_MAIN)))
        pages.append(OnBoardingNotifyViewModel(lottieAnimationName: "Notify", mainText: LocalizableStringResource(stringResource: R.string.localizable.onboarding_NOTIFY_MAIN), onDoNotAllowNotifyHandler: onDoNotAllowNotifyAction))
        pages.append(OnBoardingSpeechViewModel(lottieAnimationName: "Speech", mainText: LocalizableStringResource(stringResource: R.string.localizable.onboarding_SPEECH_MAIN), onDoNotAllowNotifyHandler: onDoNotAllowSpeechAction))
    }
    
    func onDoNotAllowNotifyAction() {
        if let action = onDoNotAllowNotify {
            action()
        }
    }
    
    func onDoNotAllowSpeechAction() {
        if let action = onDoNotAllowSpeech {
            action()
        }
    }
}
