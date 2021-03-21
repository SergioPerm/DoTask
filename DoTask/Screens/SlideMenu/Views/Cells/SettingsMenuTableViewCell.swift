//
//  TopMenuTableViewCell.swift
//  DoTask
//
//  Created by kluv on 27/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

class SettingsMenuTableViewCell: UITableViewCell, TableViewCellType {
    
    var viewModel: SettingsMenuItemViewModel? {
        didSet {
            bindViewModel()
        }
    }
    
    // MARK: View's properties
    
    private let settingsButton: UIButton = {
        //Settings button
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintImageWithColor(color: Color.blueColor.uiColor, image: R.image.menu.settings())
        btn.addTarget(self, action: #selector(menuSettingsAction(sender:)), for: .touchUpInside)
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

extension SettingsMenuTableViewCell {
    private func bindViewModel() {
        
    }
    
    private func setup() {
        selectionStyle = .none
        
        if #available(iOS 14.0, *) {
            contentView.addSubview(settingsButton)
        } else {
            addSubview(settingsButton)
        }
        
        let constraints = [
            settingsButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: StyleGuide.SlideMenu.Sizes.leftMargin),
            settingsButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            settingsButton.heightAnchor.constraint(equalToConstant: 25),
            settingsButton.widthAnchor.constraint(equalToConstant: 25)
        ]
        
        backgroundColor = .clear
        
        NSLayoutConstraint.activate(constraints)
    }
    
    //Use UIResponderChain
    @objc private func menuSettingsAction(sender: UIButton) { }
}
