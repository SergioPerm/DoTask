//
//  MainMenuTableViewCell.swift
//  DoTask
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
    let title1: LocalizableLabel = {
        let label = LocalizableLabel()
        label.localizableString = LocalizableStringResource(stringResource: R.string.localizable.create_SHORTCUT)
        label.font = FontFactory.HelveticaNeueBold.of(size: StyleGuide.getSizeRelativeToScreenWidth(baseSize: 19))
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
        btn.setImage(R.image.menu.addPlus(), for: .normal)
        btn.contentMode = .center
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
        title1.font = title1.font.withSize(globalWidth * StyleGuide.SlideMenu.Sizes.RatioToScreenWidth.ratioToScreenWidthFontSizeSmallTitle)
        
        contentView.addSubview(title1)
        contentView.addSubview(createShortcutBtn)
        
        let widthConstraint = title1.widthAnchor.constraint(equalToConstant: 150)
        let constraints = [
            title1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: StyleGuide.SlideMenu.Sizes.leftMargin),
            title1.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            title1.heightAnchor.constraint(equalToConstant: 25),
            widthConstraint,
            createShortcutBtn.leadingAnchor.constraint(equalTo: title1.trailingAnchor),
            createShortcutBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            createShortcutBtn.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            createShortcutBtn.heightAnchor.constraint(equalToConstant: 25),
            createShortcutBtn.widthAnchor.constraint(equalToConstant: 45)
        ]
        
        createShortcutBtn.imageEdgeInsets = StyleGuide.SlideMenu.CreateShortcut.Sizes.createBtnImgInsets
        
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

