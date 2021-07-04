//
//  OnBoardingNotifyViewModel.swift
//  DoTask
//
//  Created by Sergio Lechini on 14.06.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation

protocol OnBoardingNotifyViewModelInputs {
    func allowNotify()
}

protocol OnBoardingNotifyViewModelOutputs {
    var lottieAnimationName: String { get }
    var mainText: LocalizableStringResource { get }
    var hideAllowBtnAfterCheckEvent: Event<Void> { get }
}

protocol OnBoardingNotifyViewModelType: AnyObject {
    var inputs: OnBoardingNotifyViewModelInputs { get }
    var outputs: OnBoardingNotifyViewModelOutputs { get }
}

final class OnBoardingNotifyViewModel: OnBoardingNotifyViewModelType, OnBoardingNotifyViewModelInputs, OnBoardingNotifyViewModelOutputs, OnBoardingScreenType {
    
    var inputs: OnBoardingNotifyViewModelInputs { return self }
    var outputs: OnBoardingNotifyViewModelOutputs { return self }
        
    private var onDoNotAllowNotify: (()->())?
    
    init(lottieAnimationName: String, mainText: LocalizableStringResource, onDoNotAllowNotifyHandler: (()->())?) {
        self.lottieAnimationName = lottieAnimationName
        self.mainText = mainText
        self.hideAllowBtnAfterCheckEvent = Event<Void>()
        self.onDoNotAllowNotify = onDoNotAllowNotifyHandler
    }
    
    // MARK: Inputs
    
    func allowNotify() {
        let pushNotificationService: PushNotificationService = AppDI.resolve()
        pushNotificationService.checkAuthorization { [weak self] didAllow in
            guard let strongSelf = self else { return }
            if didAllow {
                strongSelf.hideAllowBtnAfterCheckEvent.raise()
            } else {
                if let onDoNotAllowNotify = strongSelf.onDoNotAllowNotify {
                    onDoNotAllowNotify()
                }
            }
        }
    }
    
    // MARK: Outputs
    
    var lottieAnimationName: String
    var mainText: LocalizableStringResource
    
    var hideAllowBtnAfterCheckEvent: Event<Void>
}
