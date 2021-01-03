//
//  SubtaskTableViewCell.swift
//  Tasker
//
//  Created by KLuV on 22.12.2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

protocol SubtaskTableViewCellDelegate: class {
    func updateHeightOfRow()
    func deleteSubtask(_ subtaskViewModel: SubtaskViewModelType, cell: SubtaskTableViewCell)
    func reorderCell(_ cell: SubtaskTableViewCell, gestureRecognizer: UILongPressGestureRecognizer)
}

class SubtaskTableViewCell: UITableViewCell {

    private weak var heightConstraint: NSLayoutConstraint?
        
    private let checkViewHeight: CGFloat = 33 * 0.6
    
    // MARK: External properties
    
    weak var cellDelegate: SubtaskTableViewCellDelegate?
        
    weak var parentScrollView: DetailTaskScrollView? {
        didSet {
            guard let parentScrollView = parentScrollView else {
                return
            }
            titleTextView.parentScrollView = parentScrollView
        }
    }
    
    weak var subtaskViewModel: SubtaskViewModelType? {
        didSet {
            guard let viewModel = subtaskViewModel else {
                checkView.check = false
                titleTextView.text = ""
                return
            }
            
            checkView.check = viewModel.outputs.isDone
            titleTextView.text = viewModel.outputs.title
            titleTextView.layoutSubviews()
            updateTextViewStyle()
        }
    }
    
    func setActive() {
        self.titleTextView.becomeFirstResponder()
    }
    
    private var checkView: CheckCellButton = CheckCellButton()
    
    private let doneView: UIView = {
        let tapView = UIView()
        tapView.translatesAutoresizingMaskIntoConstraints = false
                
        return tapView
    }()
    
    let titleTextView: TaskTitleTextView = {
        let textView = TaskTitleTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    private let deleteButton: UIButton = {
        let deleteBtn = UIButton()
        
        deleteBtn.tintImageWithColor(color: .gray, image: UIImage(named: "cancel"))
        deleteBtn.translatesAutoresizingMaskIntoConstraints = false
        
        return deleteBtn
    }()
    
    private let reorderButton: ReorderCellButton = {
        let reorderBtn = ReorderCellButton()
        reorderBtn.translatesAutoresizingMaskIntoConstraints = false
        
        return reorderBtn
    }()
    
    // MARK: Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        heightConstraint?.constant = 33
        layoutIfNeeded()
    }
}

extension SubtaskTableViewCell {
    
    // MARK: Setup Cell
    
    private func setup() {
        titleTextView.delegate = self
        
        selectionStyle = .none
        
        //setupCheckView()
        
        titleTextView.placeholderText = "Subtask title"
        titleTextView.titleFont = FontFactory.TypeWriting.of(size: 15)
        
        checkView = CheckCellButton(check: subtaskViewModel?.outputs.isDone ?? false)
        checkView.translatesAutoresizingMaskIntoConstraints = false
        
        doneView.addSubview(checkView)
        contentView.addSubview(doneView)
        
        contentView.addSubview(titleTextView)
        
        
        contentView.addSubview(deleteButton)
        contentView.addSubview(reorderButton)

        let huggingPriority = UILayoutPriority(250)
        deleteButton.setContentHuggingPriority(huggingPriority, for: .vertical)
        deleteButton.contentEdgeInsets = UIEdgeInsets(top: 7.5, left: 7.5, bottom: 7.5, right: 7.5)
        
        deleteButton.isHidden = true
        
        reorderButton.setContentHuggingPriority(huggingPriority, for: .vertical)
        
        heightConstraint = titleTextView.heightAnchor.constraint(equalToConstant: 33)
        
        let constraints = [
            doneView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            doneView.topAnchor.constraint(equalTo: contentView.topAnchor),
            doneView.heightAnchor.constraint(equalToConstant: 33),
            doneView.widthAnchor.constraint(equalToConstant: 33),
            checkView.leadingAnchor.constraint(equalTo: doneView.leadingAnchor),
            checkView.centerYAnchor.constraint(equalTo: doneView.centerYAnchor),
            checkView.heightAnchor.constraint(equalToConstant: checkViewHeight),
            checkView.widthAnchor.constraint(equalToConstant: checkViewHeight),
            heightConstraint!,
            titleTextView.leadingAnchor.constraint(equalTo: doneView.trailingAnchor, constant: 5),
            titleTextView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleTextView.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -5),
            titleTextView.trailingAnchor.constraint(equalTo: reorderButton.leadingAnchor, constant: -5),
            titleTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: 33),
            deleteButton.widthAnchor.constraint(equalToConstant: 33),
            reorderButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            reorderButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            reorderButton.heightAnchor.constraint(equalToConstant: 33),
            reorderButton.widthAnchor.constraint(equalToConstant: 33)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        let doneTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(doneTapAction(sender:)))
        doneView.addGestureRecognizer(doneTapRecognizer)
        
        let deleteTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(deleteSubtaskAction(sender:)))
        deleteButton.addGestureRecognizer(deleteTapRecognizer)
        
        let reorderLongTap = UILongPressGestureRecognizer(target: self, action: #selector(reorderCellAction(sender:)))
        reorderLongTap.minimumPressDuration = 0.2
        reorderButton.addGestureRecognizer(reorderLongTap)
    }
        
    private func updateTextViewStyle() {
        guard let viewModel = subtaskViewModel else {
            titleTextView.textColor = .black
            return
        }
        titleTextView.textColor = viewModel.outputs.isDone ? .gray : .black
        titleTextView.strikeTroughText = viewModel.outputs.isDone
    }
    
    private func updateControlButtons() {
        deleteButton.isHidden = titleTextView.isFocused
        reorderButton.isHidden = !titleTextView.isFocused
    }
    
    @objc private func reorderCellAction(sender: UILongPressGestureRecognizer) {
        if let delegate = cellDelegate {
            delegate.reorderCell(self, gestureRecognizer: sender)
        }
    }
    
    @objc private func doneTapAction(sender: UITapGestureRecognizer) {
        guard let viewModel = subtaskViewModel else { return }
        viewModel.inputs.setDone(done: !viewModel.outputs.isDone)
        
        checkView.check = viewModel.outputs.isDone
        updateTextViewStyle()
    }
    
    @objc private func deleteSubtaskAction(sender: UITapGestureRecognizer) {
        if let delegate = cellDelegate, let subtaskViewModel = subtaskViewModel {
            delegate.deleteSubtask(subtaskViewModel, cell: self)
        }
    }
}

extension SubtaskTableViewCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        deleteButton.isHidden = false
        reorderButton.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        deleteButton.isHidden = true
        reorderButton.isHidden = false
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        subtaskViewModel?.inputs.setTitle(title: textView.text)
        
        let newSize = textView.sizeThatFits(CGSize(width: textView.frame.width,
                                                   height: CGFloat.greatestFiniteMagnitude))

        heightConstraint?.constant = newSize.height
        if let delegate = cellDelegate {
            delegate.updateHeightOfRow()
        }
    }
}