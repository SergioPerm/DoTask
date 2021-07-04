//
//  ShortcutListTableViewCell.swift
//  DoTask
//
//  Created by KLuV on 12.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit
import SnapKit

class ShortcutListTableViewCell: UITableViewCell {

    var viewModel: ShortcutViewModelType? {
        didSet {
            guard let _ = viewModel else {
                color = R.color.commonColors.clear()!
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
    
    private let showInMainListIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = R.image.shortcutList.hidden()?.maskWithColor(color: .gray)
        imageView.contentMode = .scaleAspectFit
        
        return imageView
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
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
                
}

private extension ShortcutListTableViewCell {
        
    func bindViewModel() {
        
        guard let viewModel = viewModel else { return }
        
        color = UIColor(hexString: viewModel.outputs.color)
        titleLabel.text = viewModel.outputs.title
        showInMainListIcon.isHidden = viewModel.outputs.showInMainList
        
        drawDot()
    }
    
    func drawDot() {
        dotShape.removeFromSuperlayer()
        
        let rowHeight = StyleGuide.ShortcutList.Sizes.tableRowHeight
        let radius = StyleGuide.ShortcutList.Sizes.ratioToParentFrame.shortcutDotRadius * rowHeight
        
        let path = UIBezierPath(ovalIn: CGRect(x: rowHeight/2 - radius, y: rowHeight/2 - radius, width: radius * 2, height: radius * 2))
        
        dotShape.path = path.cgPath
        
        dotShape.fillColor = color.cgColor
        dotShape.strokeColor = color.cgColor
               
        colorDotView.layer.addSublayer(dotShape)
    }
    
    func setup() {
        selectionStyle = .none
        
        let globalWidth = UIView.globalSafeAreaFrame.width
        titleLabel.font = titleLabel.font.withSize(globalWidth * StyleGuide.SlideMenu.Sizes.RatioToScreenWidth.ratioToScreenWidthFontSizeMiddleTitle)
                
        contentView.addSubview(colorDotView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(showInMainListIcon)
        
        backgroundColor = .clear
    }
    
    func setupConstraints() {
        
        colorDotView.snp.makeConstraints({ make in
            make.left.centerY.equalToSuperview()
            make.width.height.equalTo(50)
            make.right.equalTo(titleLabel.snp.left)
        })
        
        titleLabel.snp.makeConstraints({ make in
            make.centerY.equalToSuperview()
            make.right.equalTo(showInMainListIcon.snp.left)
            make.height.equalTo(50)
        })
        
        showInMainListIcon.snp.makeConstraints({ make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-15)
            make.width.height.equalTo(20)
        })
        
    }
    
    
}
