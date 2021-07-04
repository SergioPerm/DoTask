//
//  OnboardingDependency.swift
//  DoTask
//
//  Created by Sergio Lechini on 14.06.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import Foundation
import DITranquillity

class OnBoardingDependency: DIPart {
    static func load(container: DIContainer) {
  
        container.register(OnBoardingViewModel.init).as(OnboardingViewModelType.self).lifetime(.prototype)
        
        container.register({
            OnBoardingViewController(viewModel: $0, router: $1, presentableControllerViewType: .containerChild)
        }).as(OnboardingViewType.self)
        
    }
}
