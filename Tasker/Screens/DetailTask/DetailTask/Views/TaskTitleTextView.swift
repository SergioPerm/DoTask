//
//  TaskTitleTextView.swift
//  Tasker
//
//  Created by KLuV on 15.12.2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

class TaskTitleTextView: UITextView {
    
    weak var parentScrollView: DetailTaskScrollViewType?

    var placeholderText: String = ""
    var titleFont: UIFont?
    
    var strikeTroughText: Bool = false {
        didSet {
            updateStrikeTroughText()
        }
    }
    
    private let placeholderLabel: UILabel = UILabel()
    private var previousCaretRect: CGRect = .zero
    private var previousTextViewFrame: CGRect = .zero
    
    init() {
        super.init(frame: .zero, textContainer: nil)
        addObservers()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addObservers()
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
        addKeyboardObserver()
        //print("is edit: \(text!)")
        
        return result
    }
    
    override func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        removeKeyboardObserver()
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
        
        font = titleFont ?? Font.detailTaskStandartTitle.uiFont
        
        isScrollEnabled = false
        bounces = false
        
        placeholderLabel.text = placeholderText
        placeholderLabel.font = titleFont ?? Font.detailTaskStandartTitle.uiFont
        placeholderLabel.sizeToFit()
        addSubview(placeholderLabel)
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
        if notification.name == UITextView.textDidBeginEditingNotification {
            //DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                //self.updateParentScrollViewOffset()
            //}
        } else {
            updateParentScrollViewOffset()
        }
    }
    
    func updateParentScrollViewOffset() {
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
        //if isFirstResponder {
            updateParentScrollViewOffset()
        //}
    }
    
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShowNotification(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    private func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(notification:)), name: UITextView.textDidChangeNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(notification:)), name: UITextView.textDidBeginEditingNotification, object: self)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShowNotification(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    private func deleteObservers() {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: self)
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidBeginEditingNotification, object: self)
        
        //NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        //NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
}
