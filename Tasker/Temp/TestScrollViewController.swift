//
//  TestScrollViewController.swift
//  Tasker
//
//  Created by KLuV on 10.12.2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

struct SubtaskModel {
    var text: String
}

class TestScrollViewController: UIViewController, Storyboarded, PresentableController {
    var presentableControllerViewType: PresentableControllerViewType = .modalViewController
    var presenter: PresenterController?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textView: TaskTitleTextView!
    @IBOutlet weak var accessoryView: UIView!
    @IBOutlet weak var accessoryBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    

    
    var keyBoardOriginY: CGFloat = 0
    var textViewLineHeight: CGFloat = 0
    var previousTextViewRect: CGRect = .zero
    
    var subtasks: [SubtaskModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.bounces = false
        textView.becomeFirstResponder()
        textView.isScrollEnabled = false
        textView.text = "Test text ................................"
        
        textView.parentScrollView = scrollView
        
        tableView.dataSource = self
        
        subtasks.append(SubtaskModel(text: ""))
        
        
        let footer = UIView()
        footer.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 33)
        
        let footerTitle = UILabel()
        footerTitle.translatesAutoresizingMaskIntoConstraints = false
        footerTitle.text = " -> Add new subtask"
        footerTitle.font = Font.detailTaskStandartTitle.uiFont
        footerTitle.textColor = .gray
        footerTitle.backgroundColor = .green
        
        footer.addSubview(footerTitle)
        
        let constraints = [
            footerTitle.centerYAnchor.constraint(equalTo: footer.centerYAnchor),
            footerTitle.leadingAnchor.constraint(equalTo: footer.leadingAnchor, constant: 20),
            footerTitle.trailingAnchor.constraint(equalTo: footer.trailingAnchor, constant: -20),
            footerTitle.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapFooterAction(sender:)))
        footer.addGestureRecognizer(tapGesture)
        
        tableView.tableFooterView = footer
        
        
        //Notifications
        setupNotifications()
    }
    
    deinit {
        deleteNotifications()
    }
}

extension TestScrollViewController {
    // MARK: Notifications
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func deleteNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc private func keyboardWillHideNotification(notification: NSNotification) {
        updateTextViewLowerLimit(notification: notification)
        textView.updateParentScrollViewOffset()
        updateBottomLayoutConstraintWithNotification(notification: notification, kbShow: false)
    }
    
    @objc private func keyboardWillShowNotification(notification: NSNotification) {
        updateTextViewLowerLimit(notification: notification)
        textView.updateParentScrollViewOffset()
        updateBottomLayoutConstraintWithNotification(notification: notification, kbShow: true)
    }
    
    private func updateTextViewLowerLimit(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let convertedKeyboardEndFrame = view.convert(keyboardEndFrame, from: view.window)
            
            keyBoardOriginY = convertedKeyboardEndFrame.origin.y - 60
            textView.lowerLimitToScroll = keyBoardOriginY
        }
    }
    
    private func updateBottomLayoutConstraintWithNotification(notification: NSNotification, kbShow: Bool) {
        let userInfo = notification.userInfo!
        
        let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let keyboardEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let convertedKeyboardEndFrame = view.convert(keyboardEndFrame, from: view.window)
        let rawAnimationCurve = (notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).uint32Value << 16
        let animationCurve = UIView.AnimationOptions.init(rawValue: UInt(rawAnimationCurve))
        
        let correctionSpaceForBottomSafeArea = notification.name == UIResponder.keyboardWillHideNotification ? view.globalSafeAreaInsets.bottom : 0
        
        accessoryBottomConstraint.constant = (kbShow ? -1 : 1) * (convertedKeyboardEndFrame.minY - view.bounds.maxY - correctionSpaceForBottomSafeArea)
        
        UIView.animate(withDuration: animationDuration,
                       delay: 0.0,
                       options: [.beginFromCurrentState, animationCurve],
                       animations: {
                        self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

extension TestScrollViewController: UITableViewDelegate {
    
    @objc private func tapFooterAction(sender: UITapGestureRecognizer) {
        
        CATransaction.begin()
        tableView.beginUpdates()
        
        let newIndexPath = IndexPath(row: subtasks.count, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .top)
        
        subtasks.append(SubtaskModel(text: ""))
        
        tableView.endUpdates()
        updateTableViewSize()
        
        let activeCell = tableView.cellForRow(at: newIndexPath) as! SubTaskTableViewCell
        activeCell.textView.becomeFirstResponder()
        
        CATransaction.setCompletionBlock { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self?.updateScrollSizeAfterChangeSubtasks(addRowHeight: activeCell.frame.height)
            }
        }
        
        CATransaction.commit()
    }

}

extension TestScrollViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subtasks.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubTaskTableViewCell", for: indexPath) as! SubTaskTableViewCell
        cell.cellDelegate = self
        cell.textView.parentScrollView = scrollView
        cell.textView.lowerLimitToScroll = keyBoardOriginY
        cell.textView.placeholderText = "New subtask"
        
        cell.textView.text = subtasks[indexPath.row].text
        
        return cell
    }
    
}

extension TestScrollViewController: SubTaskTableViewCellProtocol {
    func deleteSubtask(_ cell: SubTaskTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            tableView?.beginUpdates()
            guard let cellHeight = tableView.cellForRow(at: indexPath)?.frame.height else { return }
            tableView.deleteRows(at: [indexPath], with: .left)
            subtasks.remove(at: indexPath.row)
            
            if subtasks.count > 0 {
                let activeCellIndex = indexPath.row == 0 ? 1 : indexPath.row - 1
                let activeCellIndexPath = IndexPath(row: activeCellIndex, section: 0)
                let activeCell = tableView.cellForRow(at: activeCellIndexPath) as! SubTaskTableViewCell
                activeCell.textView.becomeFirstResponder()
            } else {
                textView.becomeFirstResponder()
            }
            
            tableView?.endUpdates()
            updateScrollSizeAfterChangeSubtasks(addRowHeight: -cellHeight)
            updateTableViewSize()
        }
    }
    
    func updateHeightOfRow(_ cell: SubTaskTableViewCell, _ textView: UITextView) {
        tableView?.beginUpdates()
        tableView?.endUpdates()
        
        updateTableViewSize()
    }
    
    func updateScrollSizeAfterChangeSubtasks(addRowHeight: CGFloat) {
        let currentTableViewFrameAtMainView = tableView.convert(tableView.bounds, to: view.window)
        
        if currentTableViewFrameAtMainView.maxY > keyBoardOriginY {
            scrollView.isScrollEnabled = true
            
            var scrollViewContentOffset = scrollView.contentOffset
            let addOffset = currentTableViewFrameAtMainView.maxY - keyBoardOriginY
            scrollViewContentOffset.y += addOffset
            
            scrollView.setContentOffset(scrollViewContentOffset, animated: true)
            scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: scrollView.contentSize.height + addOffset)
            
        } else if scrollView.contentOffset.y > 0 && addRowHeight < 0 {
            
            if abs(addRowHeight) > scrollView.contentOffset.y {
                scrollView.isScrollEnabled = false
                scrollView.setContentOffset(.zero, animated: false)
            } else {
                var scrollViewContentOffset = scrollView.contentOffset
                scrollViewContentOffset.y += addRowHeight
                
                scrollView.setContentOffset(scrollViewContentOffset, animated: false)
                scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: scrollView.contentSize.height + scrollViewContentOffset.y)
            }
        }
    }
    
    func updateTableViewSize() {
        tableView.layoutIfNeeded()
        if tableView.contentSize.height != tableViewHeightConstraint.constant {
            let addSize = tableView.contentSize.height - tableViewHeightConstraint.constant
            
            tableViewHeightConstraint.constant += addSize
        }
    }
}

