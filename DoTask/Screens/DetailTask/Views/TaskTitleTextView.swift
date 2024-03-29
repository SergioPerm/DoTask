//
//  TaskTitleTextView.swift
//  DoTask
//
//  Created by KLuV on 15.12.2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

class TaskTitleTextView: UITextView {
    
    weak var parentScrollView: DetailTaskScrollViewType?

    var placeholderText: LocalizableStringResource?
    
    var strikeTroughText: Bool = false {
        didSet {
            updateStrikeTroughText()
        }
    }
    
    private let placeholderLabel: LocalizableLabel = LocalizableLabel()
    private var previousCaretRect: CGRect = .zero
    private var previousTextViewFrame: CGRect = .zero
    
    private var isActive: Bool = false
    
    init() {
        super.init(frame: .zero, textContainer: nil)
        addObservers()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
        
    deinit {
        deleteObservers()
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        setup()
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        updateFramesAndVisible()
    }
    
    override func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        isActive = true

        return result
    }

    override func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        isActive = false
        
        return result
    }
}

extension TaskTitleTextView {

    private func updateStrikeTroughText() {
        //Main striketrough text
        let attributeString = NSMutableAttributedString(attributedString: attributedText)
                
        if strikeTroughText {
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        } else {
            attributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, attributeString.length))
        }
        
        attributedText = attributeString
        
        //Placeholder striketrough text
        guard let attributedPlaceholderText = placeholderLabel.attributedText else { return }
        
        let attributePlaceHolderString = NSMutableAttributedString(attributedString: attributedPlaceholderText)
        
        if strikeTroughText {
            attributePlaceHolderString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributePlaceHolderString.length))
        } else {
            attributePlaceHolderString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, attributePlaceHolderString.length))
        }
        
        placeholderLabel.attributedText = attributePlaceHolderString
    }
    
    private func updateFramesAndVisible() {
        placeholderLabel.frame = CGRect(x: 0, y: 5, width: placeholderLabel.frame.width, height: frame.height * 0.8)
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    private func setup() {
        textContainerInset.left = 0
        textContainer.lineFragmentPadding = 0
        
        isScrollEnabled = false
        bounces = false
        
        placeholderLabel.localizableString = placeholderText
        placeholderLabel.font = font
        placeholderLabel.sizeToFit()
        addSubview(placeholderLabel)
        placeholderLabel.textColor = R.color.detailTask.placeholder()
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
        
        if !isActive { return }
        
        if parentScrollView?.limitToScroll == 0.0 {
            return
        }
        
        placeholderLabel.isHidden = !text.isEmpty
        
        //resize to content
        resize()
                           
        guard let parentScrollView = parentScrollView, let currentTextPosition = selectedTextRange?.end else { return }

        let currentTextViewRect = caretRect(for: currentTextPosition)
        let currentTextViewRectAtMainView = convert(currentTextViewRect, to: window)

        var scrollViewContentOffset = parentScrollView.contentOffset
 
        if currentTextViewRectAtMainView.maxY > parentScrollView.limitToScroll {
            //change offset when caret behind keyboard
            parentScrollView.isScrollEnabled = true
            scrollViewContentOffset.y += currentTextViewRectAtMainView.maxY - parentScrollView.limitToScroll
        }
                
        if parentScrollView.contentOffset != scrollViewContentOffset {
            parentScrollView.setContentOffset(scrollViewContentOffset, animated: true)
        }
    }
    
    @objc private func keyboardDidShowNotification(notification: NSNotification) {
        updateParentScrollViewOffset()
    }
    
//    private func addKeyboardObserver() {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShowNotification(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
//    }
//
//    private func removeKeyboardObserver() {
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
//    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(notification:)), name: UITextView.textDidChangeNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(notification:)), name: UITextView.textDidBeginEditingNotification, object: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShowNotification(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    private func deleteObservers() {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: self)
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidBeginEditingNotification, object: self)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
    }
}
