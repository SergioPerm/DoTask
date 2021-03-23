//
//  MainMenuTableViewCell.swift
//  DoTask
//
//  Created by kluv on 27/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

class ShortcutMenuTableViewCell: UITableViewCell, TableViewCellType {

    var viewModel: ShortcutMenuItemViewModel? {
        didSet {
            bindViewModel()
        }
    }
    
    // MARK: View's properties
    private let title: UILabel = {
       let label = UILabel()
        label.font = FontFactory.HelveticaNeueBold.of(size: StyleGuide.getSizeRelativeToScreenWidth(baseSize: 17))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    private let shapeView: UIView = {
       let view = UIView()
        view.layer.cornerRadius = StyleGuide.SlideMenu.ShortcutItem.Sizes.cornerRadius
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

    override func layoutSubviews() {
        super.layoutSubviews()
    }

}

extension ShortcutMenuTableViewCell {
    
    func updateCell() {
        bindViewModel()
    }
    
    private func bindViewModel() {
        guard let viewModel = viewModel else {
            title.text = ""
            shapeView.backgroundColor = .clear
            return
        }
        
        title.text = viewModel.shortcut.name
        shapeView.backgroundColor = UIColor(hexString: viewModel.shortcut.color)
        
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
        title.font = title.font.withSize(globalWidth * StyleGuide.SlideMenu.Sizes.RatioToScreenWidth.ratioToScreenWidthFontSizeMiddleTitle)
        
        contentView.addSubview(shapeView)

        shapeView.addSubview(title)
        
        let constraints = [
            shapeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: StyleGuide.SlideMenu.Sizes.leftMargin),
            shapeView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -StyleGuide.SlideMenu.Sizes.leftMargin),
            shapeView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            shapeView.heightAnchor.constraint(equalToConstant: 33),
            title.leadingAnchor.constraint(equalTo: shapeView.leadingAnchor, constant: 8),
            title.centerYAnchor.constraint(equalTo: shapeView.centerYAnchor),
            title.heightAnchor.constraint(equalToConstant: 25),
            title.trailingAnchor.constraint(equalTo: shapeView.trailingAnchor, constant: -8)
        ]

        backgroundColor = .clear

        NSLayoutConstraint.activate(constraints)
    }
}
