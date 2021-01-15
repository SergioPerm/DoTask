//
//  ColorSelectionView.swift
//  Tasker
//
//  Created by KLuV on 05.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class ColorSelectionView: UIView {

    var presetColors: [UIColor] = []
    var selectedColor: UIColor? {
        didSet {
            guard let selectedColor = selectedColor else {
                if let selectedCell = selectedCell {
                    selectedCell.selectedColor = false
                }
                return
            }
            
            if let index = presetColors.firstIndex(where: { color in return selectedColor.description == color.description}) {
                let indexPath = IndexPath(row: index, section: 0)
                if let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell {
                    selectedCell = cell
                    cell.selectedColor = true
                    
                    collectionView.scrollToItem(at: indexPath, at: .right, animated: true)
                }
            }
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
                
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        
        return collectionView
    }()
    
    private let borderShape: CAShapeLayer = CAShapeLayer()
    
    private var selectedCell: ColorCollectionViewCell?
    
    var colorSelectionHandler: ((_ color: UIColor?) -> Void)?
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateShapes()
    }
    
}

extension ColorSelectionView {
    private func setup() {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .white
        addSubview(collectionView)
        
        collectionView.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: ColorCollectionViewCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.minimumLineSpacing = 0.0
        
        let constraints = [
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    private func updateShapes() {
        borderShape.removeFromSuperlayer()
        
        borderShape.frame = CGRect(x: 0, y: 0, width: frame.width, height: 1)
        borderShape.backgroundColor = #colorLiteral(red: 0.8463017875, green: 0.8463017875, blue: 0.8463017875, alpha: 1).cgColor
        
        layer.addSublayer(borderShape)
    }
}

extension ColorSelectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ColorCollectionViewCell
        
        if let selectedCell = selectedCell {
            selectedCell.selectedColor = false
        }
        
        selectedCell = cell
        cell.selectedColor = true
        
        if let colorSelectAction = colorSelectionHandler {
            colorSelectAction(cell.cellColor)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 50, height: 50)
    }
}

extension ColorSelectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presetColors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCollectionViewCell.reuseIdentifier, for: indexPath) as! ColorCollectionViewCell
        
        cell.cellColor = presetColors[indexPath.row]
        
        return cell
    }
}
