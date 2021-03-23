//
//  TaskReminderInfoTableViewCell.swift
//  DoTask
//
//  Created by KLuV on 01.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class TaskReminderTableViewCell: UITableViewCell, DetailTaskCellType {

    var viewModel: TaskReminderViewModelType? {
        didSet {
            bindViewModel()
        }
    }
    
    private let infoImage: UIImageView = {
        let imgView = UIImageView(image: R.image.detailTask.reminder()?.maskWithColor(color: .gray))
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        
        return imgView
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.textAlignment = .left
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

extension TaskReminderTableViewCell {
    
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
            infoLabel.heightAnchor.constraint(equalToConstant: StyleGuide.getSizeRelativeToScreenWidth(baseSize: 40))
        ]
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    private func setupActions() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(openReminderAction(sender:)))
        infoLabel.addGestureRecognizer(tapRecognizer)
    }
    
    private func bindViewModel() {
        viewModel?.outputs.timeInfo.bind { [weak self] timeInfo in
            if let timeInfo = timeInfo {
                self?.infoLabel.text = timeInfo
                self?.infoImage.image = self?.infoImage.image?.maskWithColor(color: StyleGuide.MainColors.blue)
            } else {
                self?.infoLabel.text = "Set reminder"
                self?.infoImage.image = self?.infoImage.image?.maskWithColor(color: .gray)
            }
        }
    }
    
    @objc private func openReminderAction(sender: UITapGestureRecognizer) {
        viewModel?.inputs.openReminder()
    }
    
}
