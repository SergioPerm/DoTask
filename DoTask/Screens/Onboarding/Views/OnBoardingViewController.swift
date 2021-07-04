//
//  OnboardingViewController.swift
//  DoTask
//
//  Created by Sergio Lechini on 13.06.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit
import Lottie

class OnBoardingViewController: UIViewController, OnboardingViewType {
    
    var presentableControllerViewType: PresentableControllerViewType
    var router: RouterType?
    var persistentType: PersistentViewControllerType?
    
    // MARK: ViewModel
    private let viewModel: OnboardingViewModelType?
        
    
    // MARK: Screen factory
    private let screenFactory: OnBoardingScreenFactory = OnBoardingScreenFactory()
    private var screens: [UIView] = []
    
    // MARK: UI
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = false
        
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        //view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        
        return view
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.pageIndicatorTintColor = R.color.commonColors.blue()
        pageControl.currentPageIndicatorTintColor = R.color.commonColors.pink()
        pageControl.hidesForSinglePage = false
                
        return pageControl
    }()
    
    private let emptyView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        
        return view
    }()
    
    private let continueBtn: LocalizableButton = {
        let btn = LocalizableButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = R.color.commonColors.blue()
        btn.titleLabel?.textColor = .white
        btn.titleLabel?.textAlignment = .center
        btn.titleLabel?.font = FontFactory.HelveticaNeue.of(size: StyleGuide.getSizeRelativeToScreenWidth(baseSize: 20))
        
        btn.layer.cornerRadius = 15
        
        return btn
    }()
    
    private var startView: OnBoardingStartView?
    
    
    // MARK: Init
    init(viewModel: OnboardingViewModelType, router: RouterType?, presentableControllerViewType: PresentableControllerViewType) {
        self.viewModel = viewModel
        self.router = router
        self.presentableControllerViewType = presentableControllerViewType
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: View's lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupConstraints()
    }
            
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut) {
            self.emptyView.alpha = 0.0
        } completion: { finished in
            self.emptyView.isHidden = true
        }
    }
    
    // MARK: OnboardingViewType
    var onDoNotAllowNotify: (()->())? {
        didSet {
            viewModel?.inputs.setNotifyPermissionDontAllowHandler(handler: onDoNotAllowNotify)
        }
    }
    
    var onDoNotAllowSpeech: (()->())? {
        didSet {
            viewModel?.inputs.setSpeechPermissionDontAllowHandler(handler: onDoNotAllowSpeech)
        }
    }
    
}

// MARK: Setup
private extension OnBoardingViewController {
    func setup() {
        
        guard let viewModel = viewModel else { return }
        
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        view.addSubview(pageControl)
        view.bringSubviewToFront(pageControl)
        
        view.addSubview(emptyView)
        view.bringSubviewToFront(emptyView)
        view.addSubview(continueBtn)
        
        continueBtn.localizableString = LocalizableStringResource(stringResource: R.string.localizable.onboarding_CONTINUE)
        
        continueBtn.addTarget(self, action: #selector(continueTapAction(sender:)), for: .touchUpInside)
        
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
            
        pageControl.addTarget(self, action: #selector(pageControlAction(sender:)), for: .valueChanged)
        
        //scrollView.contentSize = CGSize(width: view.frame.width * 3, height: view.frame.height - view.globalSafeAreaInsets.top)
        scrollView.delegate = self
        
        for indexScreen in 0...viewModel.outputs.pages.count - 1 {
            let screen = screenFactory.generateScreen(viewModel: viewModel.outputs.pages[indexScreen])
            screen.translatesAutoresizingMaskIntoConstraints = false
            
            contentView.addSubview(screen)
            screens.append(screen)
        }
               
    }
    
    func setupConstraints() {
        guard let viewModel = viewModel else { return }
        let pageControlSize = pageControl.size(forNumberOfPages: viewModel.outputs.pages.count)
        
        pageControl.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.width.equalTo(pageControlSize.width)
            make.height.equalTo(30)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
        })
        
        scrollView.snp.makeConstraints({ make in
            make.top.equalTo(pageControl.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(continueBtn.snp.top)
        })
        
        continueBtn.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
        })
        
        emptyView.snp.makeConstraints({ make in
            make.left.top.right.bottom.equalToSuperview()
        })
        
        contentView.snp.makeConstraints({ make in
            make.centerY.left.top.bottom.right.equalToSuperview()
        })
        
        var previousScreen: UIView!
        screens.forEach({
            let isLastScreen = $0 == screens[screens.count-1]
            
            if previousScreen == nil {
                $0.snp.makeConstraints({ make in
                    make.left.top.bottom.equalToSuperview()
                    make.width.equalTo(view.frame.width)
                })
            } else if isLastScreen {
                $0.snp.makeConstraints({ make in
                    make.top.right.bottom.equalToSuperview()
                    make.left.equalTo(previousScreen.snp.right)
                    make.width.equalTo(view.frame.width)
                })
            } else {
                $0.snp.makeConstraints({ make in
                    make.top.bottom.equalToSuperview()
                    make.left.equalTo(previousScreen.snp.right)
                    make.width.equalTo(view.frame.width)
                })
            }
            
            previousScreen = $0
        })
    }
    
    func setIndiactorForCurrentPage()  {
        let page = (scrollView.contentOffset.x)/view.frame.width
        pageControl.currentPage = Int(page)
    }
}

// MARK: Actions

private extension OnBoardingViewController {
    @objc func pageControlAction(sender: UIPageControl) {
        
    }
    
    @objc func continueTapAction(sender: UIButton) {
        guard let viewModel = viewModel else { return }
        
        if pageControl.currentPage == viewModel.outputs.pages.count - 1 {
            router?.pop(vc: self)
        } else {
            var newContentOffset = scrollView.contentOffset
            newContentOffset.x += view.frame.width
            scrollView.setContentOffset(newContentOffset, animated: true)
            pageControl.currentPage += 1
        }
        
        if pageControl.currentPage == viewModel.outputs.pages.count - 1 {
            continueBtn.localizableString = LocalizableStringResource(stringResource: R.string.localizable.onboarding_CONTINUE_END)
        }
    }
}

// MARK: UIScrollViewDelegate
extension OnBoardingViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setIndiactorForCurrentPage()
    }
}

