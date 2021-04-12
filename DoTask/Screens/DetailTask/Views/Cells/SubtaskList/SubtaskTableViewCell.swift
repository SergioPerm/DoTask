//
//  SubtaskTableViewCell.swift
//  DoTask
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

class SubtaskTableViewCell: UITableViewCell, DetailTaskCellType {

    private weak var heightConstraint: NSLayoutConstraint?
        
    private let checkViewHeight: CGFloat = StyleGuide.DetailTask.Sizes.tableViewEstimatedHeight * StyleGuide.DetailTask.Sizes.ratioToFrameWidth.checkCircleHeight
    
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
        let _ = titleTextView.becomeFirstResponder()
        titleTextView.selectedTextRange = titleTextView.textRange(from: titleTextView.endOfDocument, to: titleTextView.endOfDocument)
        titleTextView.updateParentScrollViewOffset()
    }
    
    private var checkView: CheckSubtask = CheckSubtask()
    
    private let doneView: UIView = {
        let tapView = UIView()
        tapView.translatesAutoresizingMaskIntoConstraints = false
                
        return tapView
    }()
    
    let titleTextView: TaskTitleTextView = {
        let textView = TaskTitleTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = FontFactory.AvenirNextMedium.of(size: StyleGuide.getSizeRelativeToScreenWidth(baseSize: 17))
        textView.textColor = .systemGray
        
        return textView
    }()
    
    private let deleteButton: UIButton = {
        let deleteBtn = UIButton()
        deleteBtn.tintImageWithColor(color: .gray, image: R.image.detailTask.removeSubtask())
        deleteBtn.translatesAutoresizingMaskIntoConstraints = false
        
        return deleteBtn
    }()
    
    private let reorderButton: ReorderSubtask = {
        let reorderBtn = ReorderSubtask()
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
            
}

extension SubtaskTableViewCell {
    
    // MARK: Setup Cell
    
    private func setup() {
        titleTextView.delegate = self
        
        selectionStyle = .none
                
        titleTextView.placeholderText = LocalizableStringResource(stringResource: R.string.localizable.new_SUBTASK_PLACEHOLDER)
        
        checkView = CheckSubtask(check: subtaskViewModel?.outputs.isDone ?? false)
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
        
        heightConstraint = titleTextView.heightAnchor.constraint(equalToConstant: StyleGuide.DetailTask.Sizes.tableViewEstimatedHeight)
        heightConstraint?.priority = UILayoutPriority(250)
        
        let constraints = [
            doneView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            doneView.topAnchor.constraint(equalTo: contentView.topAnchor),
            doneView.heightAnchor.constraint(equalToConstant: StyleGuide.DetailTask.Sizes.tableViewEstimatedHeight),
            doneView.widthAnchor.constraint(equalToConstant: StyleGuide.DetailTask.Sizes.tableViewEstimatedHeight),
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
            deleteButton.heightAnchor.constraint(equalToConstant: StyleGuide.DetailTask.Sizes.tableViewEstimatedHeight),
            deleteButton.widthAnchor.constraint(equalToConstant: StyleGuide.DetailTask.Sizes.tableViewEstimatedHeight),
            reorderButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            reorderButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            reorderButton.heightAnchor.constraint(equalToConstant: StyleGuide.DetailTask.Sizes.tableViewEstimatedHeight),
            reorderButton.widthAnchor.constraint(equalToConstant: StyleGuide.DetailTask.Sizes.tableViewEstimatedHeight)
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
            titleTextView.textColor = .systemGray
            return
        }
        titleTextView.textColor = viewModel.outputs.isDone ? .gray : .systemGray
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
    
    private func updateHeightOfRow() {
        let newSize = titleTextView.sizeThatFits(CGSize(width: titleTextView.frame.width,
                                                    height: CGFloat.greatestFiniteMagnitude))
        
        if heightConstraint?.constant != newSize.height {
            heightConstraint?.constant = newSize.height
            if let delegate = cellDelegate {
                delegate.updateHeightOfRow()
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        subtaskViewModel?.inputs.setTitle(title: textView.text)
        updateHeightOfRow()
    }
}
