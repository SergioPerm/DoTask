//
//  MainMenuTableViewCell.swift
//  Tasker
//
//  Created by kluv on 27/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

protocol CreateShortcutMenuTableViewCellDelegate {
    func createShortcutAction()
}

class CreateShortcutMenuTableViewCell: UITableViewCell, TableViewCellType {

    var viewModel: CreateShortcutMenuItemViewModel? {
        didSet {
            
        }
    }
    
    var cellDelegate: CreateShortcutMenuTableViewCellDelegate?
    
    // MARK: View's properties
    let title1: UILabel = {
       let label = UILabel()
        label.text = "Create shortcut"
        label.font = Font.mainMenuCellFont.uiFont
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .gray
        return label
    }()
    
    let title2: UILabel = {
       let label = UILabel()
        label.text = "+"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 22) ?? UIFont.systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.textColor = .gray
        return label
    }()
    
    let createShortcutBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "add"), for: .normal)
        btn.contentMode = .left
        btn.imageView?.contentMode = .scaleAspectFit
        
        return btn
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}

extension CreateShortcutMenuTableViewCell {
    private func setup() {
        selectionStyle = .none

        let globalWidth = UIView.globalSafeAreaFrame.width
        title1.font = title1.font.withSize(globalWidth * StyleGuide.SlideMenu.ratioToScreenWidthFontSizeSmallTitle)
                
        contentView.addSubview(title1)
        contentView.addSubview(createShortcutBtn)

        let widthConstraint = title1.widthAnchor.constraint(equalToConstant: 150)
        let constraints = [
            title1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: StyleGuide.SlideMenu.leftMargin),
            title1.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            title1.heightAnchor.constraint(equalToConstant: 25),
            widthConstraint,
            createShortcutBtn.leadingAnchor.constraint(equalTo: title1.trailingAnchor),
            createShortcutBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            createShortcutBtn.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            createShortcutBtn.heightAnchor.constraint(equalToConstant: 15),
            createShortcutBtn.widthAnchor.constraint(equalToConstant: 30)
        ]

        createShortcutBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        
        contentView.backgroundColor = .clear

        widthConstraint.priority = UILayoutPriority(rawValue: 250)
        title1.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        NSLayoutConstraint.activate(constraints)
        
        createShortcutBtn.addTarget(self, action: #selector(createShortcutAction(sender:)), for: .touchUpInside)
    }
    
    @objc private func createShortcutAction(sender: UIButton) {
        viewModel?.createShortcut()
    }
}

