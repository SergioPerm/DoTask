//
//  MainMenuTableViewCell.swift
//  Tasker
//
//  Created by kluv on 27/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

class ShortcutMenuTableViewCell: UITableViewCell {

    // MARK: View's properties
    let title: UILabel = {
       let label = UILabel()
        label.text = "Work"
        label.font = Font.additionalMenuCellFont.uiFont
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    let shapeView: UIView = {
       let view = UIView()
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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

extension ShortcutMenuTableViewCell {
    private func setup() {
        selectionStyle = .none

        let globalWidth = UIView.globalSafeAreaFrame.width
        title.font = title.font.withSize(globalWidth * StyleGuide.SlideMenu.ratioToScreenWidthFontSizeMiddleTitle)
        
        addSubview(shapeView)
        shapeView.addSubview(title)

        let constraints = [
            shapeView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: StyleGuide.SlideMenu.leftMargin),
            shapeView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -StyleGuide.SlideMenu.leftMargin),
            shapeView.centerYAnchor.constraint(equalTo: centerYAnchor),
            shapeView.heightAnchor.constraint(equalToConstant: 33),
            title.leadingAnchor.constraint(equalTo: shapeView.leadingAnchor, constant: 8),
            title.centerYAnchor.constraint(equalTo: shapeView.centerYAnchor),
            title.heightAnchor.constraint(equalToConstant: 25),
            title.widthAnchor.constraint(equalToConstant: 150)
        ]

        backgroundColor = .clear

        NSLayoutConstraint.activate(constraints)
    }
}
