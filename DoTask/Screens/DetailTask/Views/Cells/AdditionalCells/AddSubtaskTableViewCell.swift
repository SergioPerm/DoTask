//
//  AddSubtaskTableViewCell.swift
//  DoTask
//
//  Created by Сергей Лепинин on 23.03.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class AddSubtaskTableViewCell: UITableViewCell, DetailTaskCellType {

    var viewModel: AddSubtaskViewModelType?
    
    private let arrowImage: UIImageView = {
        let imgView = UIImageView(image: R.image.detailTask.addSubtaskArrow()?.maskWithColor(color: .gray))
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        
        return imgView
    }()
    
    private let addLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.textAlignment = .left
        label.text = "Add subtask"
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    // MARK: Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension AddSubtaskTableViewCell {
    private func setup() {
        contentView.backgroundColor = .white
        selectionStyle = .none
        
        contentView.addSubview(arrowImage)
        contentView.addSubview(addLabel)
        
        addLabel.font = FontFactory.HelveticaNeue.of(size: StyleGuide.getSizeRelativeToScreenWidth(baseSize: 20))
        
        setupConstraints()
        setupActions()
    }
    
    private func setupConstraints() {
        
        let constraints = [
            arrowImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            arrowImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            arrowImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            arrowImage.trailingAnchor.constraint(equalTo: addLabel.leadingAnchor, constant: -10),
            arrowImage.widthAnchor.constraint(equalToConstant: StyleGuide.getSizeRelativeToScreenWidth(baseSize: 30)),
            addLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            addLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            addLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            addLabel.heightAnchor.constraint(equalToConstant: StyleGuide.getSizeRelativeToScreenWidth(baseSize: 45))
        ]
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    private func setupActions() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(addSubtaskAction(sender:)))
        addLabel.addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func addSubtaskAction(sender: UITapGestureRecognizer) {
        viewModel?.inputs.addSubtask()
    }
    
}
