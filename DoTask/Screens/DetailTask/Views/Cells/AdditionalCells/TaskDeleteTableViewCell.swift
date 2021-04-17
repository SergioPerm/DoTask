//
//  TaskDeleteTableViewCell.swift
//  DoTask
//
//  Created by KLuV on 07.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class TaskDeleteTableViewCell: UITableViewCell, DetailTaskCellType {

    var viewModel: TaskDeleteViewModelType?
    
    private let infoImage: UIImageView = {
        let imgView = UIImageView(image: R.image.detailTask.trash()?.maskWithColor(color: .red))
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        
        return imgView
    }()
    
    private let infoLabel: LocalizableLabel = {
        let label = LocalizableLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .red
        label.textAlignment = .left
        label.localizableString = LocalizableStringResource(stringResource: R.string.localizable.deletE)
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

extension TaskDeleteTableViewCell {
    private func setup() {
        contentView.backgroundColor = .white
        selectionStyle = .none
        
        contentView.addSubview(infoImage)
        contentView.addSubview(infoLabel)
        
        infoLabel.font = FontFactory.HelveticaNeue.of(size: StyleGuide.getSizeRelativeToScreenWidth(baseSize: 17))
        
        setupConstraints()
        setupActions()
    }
    
    private func setupConstraints() {
        
        let constraints = [
            infoImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            infoImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            infoImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            infoImage.trailingAnchor.constraint(equalTo: infoLabel.leadingAnchor, constant: -10),
            infoImage.widthAnchor.constraint(equalToConstant: 20),
            infoLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            infoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            infoLabel.heightAnchor.constraint(equalToConstant: StyleGuide.DetailTask.Sizes.additionalCellLabelHeight)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    private func setupActions() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(deleteAction(sender:)))
        infoLabel.addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func deleteAction(sender: UITapGestureRecognizer) {
        viewModel?.inputs.askForDelete()
    }
    
}
