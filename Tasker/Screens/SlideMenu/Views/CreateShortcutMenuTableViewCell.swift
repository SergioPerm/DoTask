//
//  MainMenuTableViewCell.swift
//  Tasker
//
//  Created by kluv on 27/11/2020.
//  Copyright © 2020 itotdel. All rights reserved.
//

import UIKit

class CreateShortcutMenuTableViewCell: UITableViewCell {

    // MARK: View's properties
    let title1: UILabel = {
       let label = UILabel()
        label.text = "Create shortcut"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 14) ?? UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .gray
        return label
    }()
    
    let title2: UILabel = {
       let label = UILabel()
        label.text = "+"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 22) ?? UIFont.systemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.textColor = .gray
        return label
    }()
    
    let addImageView: UIImageView = {
        guard let image = UIImage(named: "add") else { return UIImageView(image: UIImage()) }
        
        let tintedImage = image.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: tintedImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .gray
    
        return imageView
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

        addSubview(title1)
        addSubview(addImageView)

        let widthConstraint = title1.widthAnchor.constraint(equalToConstant: 150)
        let constraints = [
            title1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            title1.centerYAnchor.constraint(equalTo: centerYAnchor),
            title1.heightAnchor.constraint(equalToConstant: 25),
            widthConstraint,
            addImageView.leadingAnchor.constraint(equalTo: title1.trailingAnchor),
            addImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            addImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            addImageView.heightAnchor.constraint(equalToConstant: 15),
            addImageView.widthAnchor.constraint(equalToConstant: 15)
        ]

        backgroundColor = .clear

        widthConstraint.priority = UILayoutPriority(rawValue: 250)
        title1.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        NSLayoutConstraint.activate(constraints)
        
    }
}
