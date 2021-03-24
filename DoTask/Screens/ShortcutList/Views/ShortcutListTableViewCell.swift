//
//  ShortcutListTableViewCell.swift
//  DoTask
//
//  Created by KLuV on 12.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class ShortcutListTableViewCell: UITableViewCell {

    var viewModel: ShortcutViewModelType? {
        didSet {
            guard let _ = viewModel else {
                color = UIColor.clear
                titleLabel.text = ""
                
                return
            }
    
            bindViewModel()
        }
    }
    
    private var color: UIColor = UIColor.clear {
        didSet {
            setNeedsLayout()
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let colorDotView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
                
        return view
    }()
    
    private let dotShape = CAShapeLayer()
    
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

extension ShortcutListTableViewCell {
        
    private func bindViewModel() {
        
        guard let viewModel = viewModel else { return }
        
        color = UIColor(hexString: viewModel.outputs.color)
        titleLabel.text = viewModel.outputs.title
        
        drawDot()
    }
    
    private func drawDot() {
        dotShape.removeFromSuperlayer()
        
        let rowHeight = StyleGuide.ShortcutList.Sizes.tableRowHeight
        let radius = StyleGuide.ShortcutList.Sizes.ratioToParentFrame.shortcutDotRadius * rowHeight
        
        let path = UIBezierPath(ovalIn: CGRect(x: rowHeight/2 - radius, y: rowHeight/2 - radius, width: radius * 2, height: radius * 2))
        
        dotShape.path = path.cgPath
        
        dotShape.fillColor = color.cgColor
        dotShape.strokeColor = color.cgColor
               
        colorDotView.layer.addSublayer(dotShape)
    }
    
    private func setup() {
        selectionStyle = .none
        
        let globalWidth = UIView.globalSafeAreaFrame.width
        titleLabel.font = titleLabel.font.withSize(globalWidth * StyleGuide.SlideMenu.Sizes.RatioToScreenWidth.ratioToScreenWidthFontSizeMiddleTitle)
                
        contentView.addSubview(colorDotView)
        contentView.addSubview(titleLabel)
        
        let constraints = [
            colorDotView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorDotView.widthAnchor.constraint(equalToConstant: 50),
            colorDotView.heightAnchor.constraint(equalToConstant: 50),
            colorDotView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorDotView.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 50),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ]
        
        backgroundColor = .clear
        
        NSLayoutConstraint.activate(constraints)
    }
}
