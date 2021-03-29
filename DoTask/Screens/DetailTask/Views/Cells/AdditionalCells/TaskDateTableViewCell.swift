//
//  TaskDateInfoTableViewCell.swift
//  DoTask
//
//  Created by KLuV on 31.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class TaskDateTableViewCell: UITableViewCell, DetailTaskCellType {

    var viewModel: TaskDateViewModelType? {
        didSet {
            bindViewModel()
        }
    }
    
    private let infoImage: UIImageView = {
        let imgView = UIImageView(image: R.image.detailTask.calendar()?.maskWithColor(color: .gray))
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

extension TaskDateTableViewCell {
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
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(openCalendarAction(sender:)))
        infoLabel.addGestureRecognizer(tapRecognizer)
    }
    
    private func bindViewModel() {
        viewModel?.outputs.dateInfo.bind { [weak self] dateInfo in
            if let dateInfo = dateInfo {
                self?.infoLabel.text = dateInfo
                self?.infoImage.image = self?.infoImage.image?.maskWithColor(color: R.color.commonColors.blue()!)
            } else {
                self?.infoLabel.text = "Set date"
                self?.infoImage.image = self?.infoImage.image?.maskWithColor(color: .gray)
            }
        }
    }
    
    @objc private func openCalendarAction(sender: UITapGestureRecognizer) {
        viewModel?.inputs.openCalendar()
    }
}
