//
//  SubTaskTableViewCell.swift
//  DoTask
//
//  Created by KLuV on 21.12.2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

protocol SubTaskTableViewCellProtocol: class {
    func updateHeightOfRow(_ cell: SubTaskTableViewCell, _ textView: UITextView)
    func deleteSubtask(_ cell: SubTaskTableViewCell)
}

class SubTaskTableViewCell: UITableViewCell {

    @IBOutlet weak var textView: TaskTitleTextView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    weak var cellDelegate: SubTaskTableViewCellProtocol?
    var textChangedAction: ((String) -> Void)?
    
    @IBAction func deleteSubTaskAction(_ sender: UIButton) {
        if let delegate = cellDelegate {
            delegate.deleteSubtask(self)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        heightConstraint.constant = 33
        layoutIfNeeded()
    }
    
}

extension SubTaskTableViewCell: UITextViewDelegate {
        
    func textViewDidChange(_ textView: UITextView) {

        let newSize = textView.sizeThatFits(CGSize(width: textView.frame.width,
                                                   height: CGFloat.greatestFiniteMagnitude))

        heightConstraint.constant = newSize.height
        if let delegate = cellDelegate {
            delegate.updateHeightOfRow(self, textView)
        }
    }
}

