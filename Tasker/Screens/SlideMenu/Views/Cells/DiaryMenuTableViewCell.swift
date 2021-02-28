//
//  DiaryMenuTableViewCell.swift
//  Tasker
//
//  Created by KLuV on 06.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class DiaryMenuTableViewCell: UITableViewCell, TableViewCellType {

    var viewModel: DiaryMenuItemViewModel? {
        didSet {
            bindViewModel()
        }
    }
    
    // MARK: View's properties
    let icon: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let title: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .left
        label.font = Font.mainMenuCellFont.uiFont
        label.minimumScaleFactor = 0.3
        label.translatesAutoresizingMaskIntoConstraints = false
                
        return label
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

extension DiaryMenuTableViewCell {
    private func bindViewModel() {
        guard let viewModel = viewModel else {
            title.text = ""
            icon.image = nil
            return
        }
        
        title.text = viewModel.title
        icon.image = UIImage(named: viewModel.imageName)
    }
    
    private func setup() {
        selectionStyle = .none
        
        let globalWidth = UIView.globalSafeAreaFrame.width
        title.font = title.font.withSize(globalWidth * StyleGuide.SlideMenu.ratioToScreenWidthFontSizeBigTitle)
        
        addSubview(icon)
        addSubview(title)
        
        let constraints = [
            icon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: StyleGuide.SlideMenu.leftMargin),
            icon.centerYAnchor.constraint(equalTo: centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 25),
            icon.heightAnchor.constraint(equalToConstant: 25),
            title.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 10),
            title.centerYAnchor.constraint(equalTo: centerYAnchor),
            title.heightAnchor.constraint(equalToConstant: 25),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -StyleGuide.SlideMenu.leftMargin)
        ]
        
        backgroundColor = .clear
        
        NSLayoutConstraint.activate(constraints)
    }
    
//    //Use UIResponderChain
//    @objc private func menuSettingsAction(sender: UIButton) { }
}
