//
//  TaskTitleTextView.swift
//  Tasker
//
//  Created by KLuV on 15.12.2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

class TaskTitleTextView: UITextView {
    var parentScrollView: UIScrollView = UIScrollView()
    var lowerLimitToScroll: CGFloat = 0
    
    var placeholderText: String? {
        didSet {
            setupPlaceholder()
        }
    }
    
    private let placeholderLabel: UILabel = UILabel()
    private var previousTextViewRect: CGRect = .zero
    
    init() {
        super.init(frame: .zero, textContainer: nil)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
        
    deinit {
        deleteObservers()
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        setupPlaceholder()
    }
}

extension TaskTitleTextView {
    private func commonInit() {
        addObservers()
    }
    
    private func setupPlaceholder() {
        guard let placeholderText = placeholderText else { return }
        placeholderLabel.text = placeholderText
        placeholderLabel.font = Font.detailTaskStandartTitle.uiFont
        placeholderLabel.sizeToFit()
        addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    private func resize() {
        var newFrame = frame
        let width = newFrame.size.width
        let newSize = sizeThatFits(CGSize(width: width,
                                                   height: CGFloat.greatestFiniteMagnitude))
        newFrame.size = CGSize(width: width, height: newSize.height)
        frame = newFrame
    }
            
    @objc private func textDidChange(notification: NSNotification) {
        updateParentScrollViewOffset()
    }
    
    func updateParentScrollViewOffset() {
        
        placeholderLabel.isHidden = !text.isEmpty
        
        //resize to content
        resize()
                         
        //calculate delete or add content
        let endPosition = endOfDocument
        let endTextViewRect = caretRect(for: endPosition)
                
        previousTextViewRect = previousTextViewRect == .zero ? endTextViewRect : previousTextViewRect
        
        var deleteLineHeight: CGFloat = 0.0
        if endTextViewRect.origin.y < previousTextViewRect.origin.y {
            deleteLineHeight = previousTextViewRect.origin.y - endTextViewRect.origin.y
        }
        previousTextViewRect = endTextViewRect
        //
        
        guard let currentTextPosition = selectedTextRange?.end else { return }
        let currentTextViewRect = caretRect(for: currentTextPosition)
        let currentTextViewRectAtMainView = convert(currentTextViewRect, to: window)
        
        var scrollViewContentOffset = parentScrollView.contentOffset
 
        if currentTextViewRectAtMainView.maxY > lowerLimitToScroll {
            //change offset when caret behind keyboard
            parentScrollView.isScrollEnabled = true
            scrollViewContentOffset.y += currentTextViewRectAtMainView.maxY - lowerLimitToScroll
        } else if parentScrollView.isScrollEnabled && parentScrollView.contentOffset.y > 0 && deleteLineHeight > 0 {
            //change offset when delete lines
            scrollViewContentOffset.y -= lowerLimitToScroll - currentTextViewRectAtMainView.maxY
        } else if parentScrollView.isScrollEnabled && parentScrollView.contentOffset.y <= 0 {
            //resume
            parentScrollView.isScrollEnabled = false
            scrollViewContentOffset = .zero
        }
        
        if scrollViewContentOffset.y <= 0 && deleteLineHeight > 0 {
            //correct resume
            parentScrollView.isScrollEnabled = false
            scrollViewContentOffset = .zero
        }
        
        if parentScrollView.contentOffset != scrollViewContentOffset {
            parentScrollView.setContentOffset(scrollViewContentOffset, animated: false)
            parentScrollView.contentSize = CGSize(width: parentScrollView.contentSize.width, height: parentScrollView.contentSize.height + scrollViewContentOffset.y)
        }
        print("content size \(parentScrollView.contentSize.height)")
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(notification:)), name: UITextView.textDidChangeNotification, object: self)
    }
    
    private func deleteObservers() {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: self)
    }
}
