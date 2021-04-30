//
//  DetailTaskScrollView.swift
//  DoTask
//
//  Created by KLuV on 30.12.2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

// MARK: DetailTaskScrollViewType

protocol DetailTaskScrollViewType: UIScrollView {
    var limitToScroll: CGFloat { get set }
    func setCloseHandler(handler: (() -> Void)?)
    func becomeTextInputResponder()
    func resignTextInputResponders()
    func addNewSubtask()
    var currentTitle: String { get }
    func shakeTitle()
    func updateSizes()
}

// MARK: DetailTaskScrollView

class DetailTaskScrollView: UIScrollView {

    // MARK: View's properties
    
    private let scrollContentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        return contentView
    }()
    
    private let swipeCloseView: UIView = {
        let swipeView = UIView()
        swipeView.translatesAutoresizingMaskIntoConstraints = false
        swipeView.backgroundColor = .clear

        var chevron = UIImageView()
         
        chevron = UIImageView(image: R.image.detailTask.chevron())
        chevron.contentMode = .scaleAspectFit
        chevron.translatesAutoresizingMaskIntoConstraints = false
        chevron.tintColor = R.color.detailTask.chevron()
        
        swipeView.addSubview(chevron)
        
        let constraints = [
            chevron.centerYAnchor.constraint(equalTo: swipeView.centerYAnchor),
            chevron.centerXAnchor.constraint(equalTo: swipeView.centerXAnchor),
            chevron.widthAnchor.constraint(equalTo: chevron.heightAnchor, multiplier: 2),
            chevron.heightAnchor.constraint(equalToConstant: StyleGuide.DetailTask.Sizes.chevronHeight)
        ]
        
        NSLayoutConstraint.activate(constraints)
                        
        return swipeView
    }()
    
    private let titleTextView: TaskTitleTextView = {
        let textView = TaskTitleTextView()
        textView.font = FontFactory.AvenirNextMedium.of(size: StyleGuide.getSizeRelativeToScreenWidth(baseSize: 23))
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.backgroundColor = R.color.detailTask.background()
        textView.textColor = .systemGray
        
        return textView
    }()
    
    private let subtaskTableView: SubtasksTableView = {
        let tableView = SubtasksTableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.bounces = false
        tableView.isScrollEnabled = false
        
        return tableView
    }()
        
    private weak var parentView: UIView?
    private weak var viewModel: DetailTaskViewModelType?
    
    private var detailTaskCellFactory: DetailTaskCellFactory? {
        didSet {
            detailTaskCellFactory?.cellTypes.forEach({ $0.register(subtaskTableView)})
        }
    }
    
    private var subtaskTableViewHeightConstraint: NSLayoutConstraint = NSLayoutConstraint()
    private var lowerLimitToScroll: CGFloat = 0.0
    private var tapToCloseHandler: (() -> Void)?
    private var pastActiveInput: TaskTitleTextView?
    private var subtaskTextInputs: [TaskTitleTextView?] = []
    
    private var newTask: Bool
    
    // MARK: Initializers
    
    init(viewModel: DetailTaskViewModelType) {
        self.viewModel = viewModel
        self.newTask = viewModel.outputs.isNewTask
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setup()
    }
}

// MARK: SETUP View

extension DetailTaskScrollView {
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        bounces = false
        showsHorizontalScrollIndicator = false
        isPagingEnabled = false
        
        guard let superview = superview, let viewModel = viewModel else { return }
        
        detailTaskCellFactory = DetailTaskCellFactory()
        
        parentView = superview
        
        addSubview(scrollContentView)
        scrollContentView.addSubview(swipeCloseView)
        
        titleTextView.delegate = self
        titleTextView.text = viewModel.outputs.title
        titleTextView.parentScrollView = self
        titleTextView.placeholderText = LocalizableStringResource(stringResource: R.string.localizable.new_TITLE_PLACEHOLDER)
        
        scrollContentView.addSubview(titleTextView)
        scrollContentView.addSubview(subtaskTableView)
                
        setupConstraints()
        setupActions()
        setupSubtasksTableView()
    }
        
    private func setupSubtasksTableView() {
        subtaskTableView.register(SubtaskTableViewCell.self, forCellReuseIdentifier: SubtaskTableViewCell.className)
        subtaskTableView.separatorStyle = .none
                
        subtaskTableView.estimatedRowHeight = StyleGuide.DetailTask.Sizes.tableViewEstimatedHeight
        subtaskTableView.dataSource = self
        subtaskTableView.delegate = self
    }
    
    // MARK: Constraints
    
    private func setupConstraints() {
        var constraints = [
            scrollContentView.widthAnchor.constraint(equalTo: widthAnchor),
            scrollContentView.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor),
            scrollContentView.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor),
            scrollContentView.topAnchor.constraint(equalTo: topAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            swipeCloseView.centerXAnchor.constraint(equalTo: scrollContentView.centerXAnchor),
            swipeCloseView.topAnchor.constraint(equalTo: scrollContentView.topAnchor),
            swipeCloseView.heightAnchor.constraint(equalToConstant: StyleGuide.DetailTask.Sizes.swipeCloseViewHeight),
            swipeCloseView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: StyleGuide.DetailTask.Sizes.contentSidePadding),
            swipeCloseView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -StyleGuide.DetailTask.Sizes.contentSidePadding)
        ]
        
        let heightTextViewConstraint = titleTextView.heightAnchor.constraint(equalToConstant: 30)
        heightTextViewConstraint.priority = UILayoutPriority(250)
        
        constraints.append(contentsOf: [
            titleTextView.centerXAnchor.constraint(equalTo: scrollContentView.centerXAnchor),
            titleTextView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: StyleGuide.DetailTask.Sizes.contentSidePadding),
            titleTextView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -StyleGuide.DetailTask.Sizes.contentSidePadding),
            heightTextViewConstraint,
            titleTextView.topAnchor.constraint(equalTo: swipeCloseView.bottomAnchor)
        ])
        
        subtaskTableViewHeightConstraint = subtaskTableView.heightAnchor.constraint(equalToConstant: 2000)
        subtaskTableViewHeightConstraint.priority = UILayoutPriority(250)
        
        let subtaskTableViewBottomConstraint = subtaskTableView.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor, constant: -50)
        
        constraints.append(contentsOf: [
            subtaskTableView.topAnchor.constraint(equalTo: titleTextView.bottomAnchor),
            subtaskTableView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: StyleGuide.DetailTask.Sizes.contentSidePadding),
            subtaskTableView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -StyleGuide.DetailTask.Sizes.contentSidePadding),
            subtaskTableViewHeightConstraint,
            subtaskTableViewBottomConstraint
        ])
        
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: Setup actions
    
    private func setupActions() {
        let closeTap = UITapGestureRecognizer(target: self, action: #selector(tapToCloseAction(_:)))
        swipeCloseView.addGestureRecognizer(closeTap)
    }
        
}

// MARK: Actions

extension DetailTaskScrollView {
    @objc private func tapToCloseAction(_ recognizer: UITapGestureRecognizer) {
        if let tapAction = tapToCloseHandler {
            tapAction()
        }
    }
}

// MARK: Subtasks behavior

extension DetailTaskScrollView {
                
    private func resetScrollView() {
        var scrollViewContentOffset = contentOffset
        scrollViewContentOffset.y = 0
                        
        UIView.animate(withDuration: 0.3) {
            self.setContentOffset(scrollViewContentOffset, animated: false)
        }
    }
    
    private func updateScrollSizeAfterChangeSubtasks(addRowHeight: CGFloat) {
        guard let parentView = parentView else { return }
        
        let currentTableViewFrameAtMainView = subtaskTableView.convert(subtaskTableView.bounds, to: parentView.window)
        
        var tableMaxY: CGFloat = 0
        
        if let viewModel = viewModel {
            if viewModel.outputs.tableSections.count > 1 {
                //let padding: CGFloat = 10.0
                tableMaxY = currentTableViewFrameAtMainView.maxY - (StyleGuide.DetailTask.Sizes.accesoryStackViewHeight + StyleGuide.DetailTask.Sizes.buttonsAreaHeightForScrollLimit - StyleGuide.DetailTask.Sizes.addSubtaskLabelHeight)
            } else {
                tableMaxY = currentTableViewFrameAtMainView.maxY
            }
        }
        
        if contentOffset.y >= 0 && addRowHeight < 0 {
            if abs(addRowHeight) > contentOffset.y {
                resetScrollView()
            } else {
                var scrollViewContentOffset = contentOffset
                scrollViewContentOffset.y += addRowHeight
                
                UIView.animate(withDuration: 0.3) {
                    self.setContentOffset(scrollViewContentOffset, animated: false)
                }
            }
        } else if tableMaxY > lowerLimitToScroll {
            isScrollEnabled = true
            
            var scrollViewContentOffset = contentOffset
            let addOffset = tableMaxY - lowerLimitToScroll
            scrollViewContentOffset.y += addOffset
            
            setContentOffset(scrollViewContentOffset, animated: true)
        }
    }
    
    private func setTableHeightOnStart() {
        subtaskTableView.layoutIfNeeded()
        
        let lastSectionIndex = subtaskTableView.numberOfSections - 1
        let lastRowIndex = subtaskTableView.numberOfRows(inSection: lastSectionIndex) - 1
        let rectLastRow = subtaskTableView.rectForRow(at: IndexPath(row: lastRowIndex, section: lastSectionIndex))
        
        subtaskTableViewHeightConstraint.constant = rectLastRow.maxY
    }
    
    private func updateTableViewSize(addRowHeight: CGFloat? = nil) {
                        
        subtaskTableView.layoutIfNeeded()
        if subtaskTableView.contentSize.height != subtaskTableViewHeightConstraint.constant {
            let addSize = subtaskTableView.contentSize.height - subtaskTableViewHeightConstraint.constant
            subtaskTableViewHeightConstraint.constant += addSize
        }
        
        if let addRowHeight = addRowHeight {
            subtaskTableViewHeightConstraint.constant += addRowHeight
        }
        
    }
    
    // MARK: AddSubtask
    
    private func addSubtask() {
        guard let viewModel = viewModel else { return }
        
        var newIndexPath = IndexPath()
        
        updateTableViewSize(addRowHeight: subtaskTableView.estimatedRowHeight)
        subtaskTableView.performBatchUpdates {
            newIndexPath = viewModel.inputs.addSubtask()
            
            subtaskTableView.insertRows(at: [newIndexPath], with: .top)
        } completion: { (finished) in
            let activeCell = self.subtaskTableView.cellForRow(at: newIndexPath) as! SubtaskTableViewCell
            activeCell.setActive()
        }
    }
}

// MARK: UITableViewDelegate

extension DetailTaskScrollView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let viewModel = viewModel else { return 0.0 }
        
        return CGFloat(viewModel.outputs.tableSections[section].sectionHeight)
    }
}

// MARK: UITableViewDataSource

extension DetailTaskScrollView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.outputs.tableSections[section].tableCells.count ?? 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.outputs.tableSections.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cellFactory = detailTaskCellFactory, let viewModel = viewModel else {
            return UITableViewCell()
        }
        
        let cellViewModel = viewModel.outputs.tableSections[indexPath.section].tableCells[indexPath.row]
        
        let cell = cellFactory.generateCell(viewModel: cellViewModel, tableView: subtaskTableView, for: indexPath)
        
        if let subtaskCell = cell as? SubtaskTableViewCell {
            var textViews = subtaskTextInputs.compactMap { $0 }
            textViews.append(subtaskCell.titleTextView)
            subtaskTextInputs = textViews
            
            subtaskCell.parentScrollView = self
            subtaskCell.cellDelegate = self
            
            subtaskCell.setNeedsLayout()
            subtaskCell.layoutIfNeeded()
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let viewModel = viewModel else { return UIView() }
        
        let headerHeight = CGFloat(viewModel.outputs.tableSections[section].sectionHeight)
        
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: 0, height: headerHeight)
        
        return headerView
    }
}

// MARK: SubtaskTableViewCellDelegate

extension DetailTaskScrollView: SubtaskTableViewCellDelegate {
    
    func snapshotOfCell(_ inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        
        UIGraphicsEndImageContext()
        
        let cellSnapshot : UIView = UIImageView(image: image)
        cellSnapshot.clipsToBounds = true
        cellSnapshot.layer.cornerRadius = 6.0
                        
        let outerView = UIView(frame: cellSnapshot.bounds)
        outerView.clipsToBounds = false
        outerView.layer.shadowColor = UIColor.black.cgColor
        outerView.layer.shadowOpacity = 0.4
        outerView.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        outerView.layer.shadowRadius = 10
        outerView.layer.shadowPath = UIBezierPath(roundedRect: outerView.bounds, cornerRadius: 10).cgPath
        
        outerView.addSubview(cellSnapshot)
        
        return outerView
    }
    
    func reorderCell(_ cell: SubtaskTableViewCell, gestureRecognizer: UILongPressGestureRecognizer) {
        
        guard let parentView = parentView else { return }
        
        let state = gestureRecognizer.state
        let locationInView = gestureRecognizer.location(in: parentView)
        let locationInTableView = gestureRecognizer.location(in: subtaskTableView)
        let indexPath = subtaskTableView.indexPathForRow(at: locationInTableView)
        
        struct My {
            static var cellSnapshot : UIView?
            static var cellIsAnimating : Bool = false
            static var cellNeedToShow : Bool = false
        }
        
        struct Path {
            static var initialIndexPath : IndexPath = IndexPath()
        }
        
        switch state {
        case UIGestureRecognizer.State.began:
            if let indexPath = indexPath {
                
                guard let cell = subtaskTableView.cellForRow(at: indexPath) as? SubtaskTableViewCell else { return }
                
                Path.initialIndexPath = indexPath
                My.cellSnapshot = snapshotOfCell(cell)
                guard let snapshot = My.cellSnapshot else { return }
                
                var centerInView = cell.convert(cell.center, to: parentView)
                centerInView.y = locationInView.y

                snapshot.center = centerInView
                snapshot.alpha = 0.0
                
                parentView.insertSubview(snapshot, at: parentView.subviews.count)
                
                UIView.animate(withDuration: 0.25, animations: {
                    My.cellIsAnimating = true
                    snapshot.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                    snapshot.alpha = 0.9
                    cell.alpha = 0.0
                }, completion: { finished in
                    if finished {
                        My.cellIsAnimating = false
                        if My.cellNeedToShow {
                            My.cellNeedToShow = false
                            UIView.animate(withDuration: 0.25, animations: {
                                cell.alpha = 1
                            })
                        } else {
                            cell.isHidden = true
                        }
                    }
                })
            }
        case UIGestureRecognizer.State.changed:
            if let indexPath = indexPath, let snapshot = My.cellSnapshot {
                if indexPath.section == 0 {
                    var center = snapshot.center
                    center.y = locationInView.y
                    snapshot.center = center
                    if indexPath != Path.initialIndexPath {
                        viewModel?.inputs.moveSubtask(from: Path.initialIndexPath.row, to: indexPath.row)
                        subtaskTableView.moveRow(at: Path.initialIndexPath, to: indexPath)
                        Path.initialIndexPath = indexPath
                    }
                }
            }
        default:

            if let cell = subtaskTableView.cellForRow(at: Path.initialIndexPath) as? SubtaskTableViewCell,
               let snapshot = My.cellSnapshot {
            
            if My.cellIsAnimating {
                My.cellNeedToShow = true
            } else {
                cell.isHidden = false
                cell.alpha = 0.0
            }
            
            UIView.animate(withDuration: 0.25, animations: {

                snapshot.transform = CGAffineTransform.identity
                snapshot.alpha = 0.0
                cell.alpha = 1.0
            }, completion: { finished in
                if finished {
                    snapshot.removeFromSuperview()
                    My.cellSnapshot = nil
                }
            })
            }
            
        }
    }
    
    func updateHeightOfRow() {
        subtaskTableView.beginUpdates()
        subtaskTableView.endUpdates()
        
        updateTableViewSize()
    }
    
    // MARK: DeleteSubtask
    
    func deleteSubtask(_ subtaskViewModel: SubtaskViewModelType, cell: SubtaskTableViewCell) {
        
        guard let viewModel = viewModel else {
            return
        }
        
        if let indexPath = subtaskTableView.indexPath(for: cell) {
                        
            if (viewModel.outputs.tableSections[0].tableCells.count - 1) > 0 {
                let activeCellIndex = indexPath.row == 0 ? 1 : indexPath.row - 1
                let activeCellIndexPath = IndexPath(row: activeCellIndex, section: 0)
                let activeCell = self.subtaskTableView.cellForRow(at: activeCellIndexPath) as! SubtaskTableViewCell
                activeCell.setActive()
            } else {
                let _ = self.titleTextView.becomeFirstResponder()
                self.titleTextView.selectedTextRange = self.titleTextView.textRange(from: self.titleTextView.endOfDocument, to: self.titleTextView.endOfDocument)
            }
            
            guard let cellHeight = self.subtaskTableView.cellForRow(at: indexPath)?.frame.height else { return }
            
            subtaskTableView.performBatchUpdates {
                viewModel.inputs.deleteSubtask(indexPath: indexPath)
                subtaskTableView.deleteRows(at: [indexPath], with: .top)
            } completion: { (finished) in
                if finished {
                    self.updateScrollSizeAfterChangeSubtasks(addRowHeight: -cellHeight)
                    self.updateTableViewSize()
                }
            }

        }
    }
}

// MARK: UITextViewDelegate

extension DetailTaskScrollView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let updatedTitle = (textView.text as NSString?)?.replacingCharacters(in: range, with: text) {
            viewModel?.inputs.setTitle(title: updatedTitle)
        }
        
        return true
    }
}

// MARK: DetailTaskScrollViewType
extension DetailTaskScrollView: DetailTaskScrollViewType {
    
    func updateSizes() {
        setTableHeightOnStart()
    }
        
    func becomeTextInputResponder() {
        if let pastActiveInput = pastActiveInput {
            let _ = pastActiveInput.becomeFirstResponder()
        } else {
            let _ = titleTextView.becomeFirstResponder()
        }
    }
    
    func resignTextInputResponders() {
        if titleTextView.isFirstResponder {
            pastActiveInput = titleTextView
            let _ = titleTextView.resignFirstResponder()
        } else {
            subtaskTextInputs.compactMap { $0 }.forEach {
                if $0.isFirstResponder {
                    pastActiveInput = $0
                    let _ = $0.resignFirstResponder()
                }
            }
        }
    }
    
    var limitToScroll: CGFloat {
        get {
            return lowerLimitToScroll
        }
        set {
            lowerLimitToScroll = newValue
        }
    }
    
    func addNewSubtask() {
        addSubtask()
    }
    
    func setCloseHandler(handler: (() -> Void)?) {
        tapToCloseHandler = handler
    }
        
    var currentTitle: String {
        get {
            return titleTextView.text
        }
    }
    
    func shakeTitle() {
        titleTextView.shake(duration: 1)
    }
}
