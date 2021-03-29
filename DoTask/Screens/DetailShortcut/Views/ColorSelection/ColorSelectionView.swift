//
//  ColorSelectionView.swift
//  DoTask
//
//  Created by KLuV on 05.01.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class ColorSelectionView: UIView {

    var presetColors: [ColorSelectionItemViewModelType]? {
        didSet {
            selectedCellViewModel = presetColors?.first(where: {
                $0.outputs.select == true
            })
            
            collectionView.reloadData()
            
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
    
    private let topBorder: CAShapeLayer = CAShapeLayer()
    
    private var selectedCellViewModel: ColorSelectionItemViewModelType?
    
    var colorSelectionHandler: ((_ colorHex: String) -> Void)?
    
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
        layout.sectionInset = StyleGuide.DetailShortcut.ColorSelectionView.Sizes.collectionViewLayoutSectionInset
        layout.minimumLineSpacing = StyleGuide.DetailShortcut.ColorSelectionView.Sizes.collectionViewLayoutMinLineSpacing
        
        let constraints = [
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    private func updateShapes() {
        topBorder.removeFromSuperlayer()
        
        topBorder.frame = CGRect(x: 0, y: 0, width: frame.width, height: StyleGuide.DetailShortcut.ColorSelectionView.Sizes.topBorderHeight)
        topBorder.backgroundColor = R.color.shortcutDetail.borderColor()!.cgColor
        
        layer.addSublayer(topBorder)
    }
    
    func scrollToSelected() {
        guard let indexColor = presetColors?.firstIndex(where: {
            $0.outputs.select == true
        }) else { return }
        
        collectionView.scrollToItem(at: IndexPath(row: indexColor, section: 0), at: .left, animated: true)
    }
}

extension ColorSelectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let presetColors = presetColors else { return }
        
        let cellViewModel = presetColors[indexPath.row]
        
        if let selectedCellViewModel = selectedCellViewModel {
            selectedCellViewModel.inputs.setSelected(selected: false)
        }
        
        selectedCellViewModel = cellViewModel
        cellViewModel.inputs.setSelected(selected: true)
        
        if let colorSelectAction = colorSelectionHandler {
            colorSelectAction(cellViewModel.outputs.colorHex)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let globalFrame = UIView.globalSafeAreaFrame
        let side = StyleGuide.DetailShortcut.Sizes.RatioToScreenWidth.rowHeight * globalFrame.width
        
        return CGSize(width: side, height: side)
    }
}

extension ColorSelectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presetColors?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCollectionViewCell.reuseIdentifier, for: indexPath) as! ColorCollectionViewCell
        
        cell.viewModel = presetColors?[indexPath.row]
        
        return cell
    }
}
