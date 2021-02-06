//
//  MainMenuTableViewCell.swift
//  Tasker
//
//  Created by kluv on 27/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

class MainMenuTableViewCell: UITableViewCell, MenuCellType {

    var viewModel: MainMenuItemViewModel? {
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

extension MainMenuTableViewCell {
    private func bindViewModel() {
        guard let viewModel = viewModel else {
            title.text = ""
            icon.image = nil
            return
        }
        title.text = viewModel.title
        icon.image = UIImage(named: viewModel.imageName)
        
        viewModel.selectedItem.bind { [weak self] selected in
            if selected {
                self?.backgroundColor = #colorLiteral(red: 0.7875365811, green: 0.9482855393, blue: 1, alpha: 0.71)
            } else {
                self?.backgroundColor = .white
            }
        }
        
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
