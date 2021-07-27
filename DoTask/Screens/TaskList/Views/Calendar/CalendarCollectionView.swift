//
//  CalendarCollectionView.swift
//  DoTask
//
//  Created by KLuV on 16.02.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

final class CalendarCollectionView: UICollectionView {

    private var selectedDate: Date
    private var selectedDay: CalendarDayViewModelType?
    
    var viewModel: CalendarViewModelType? {
        didSet {
            bindViewModel()
        }
    }
    
    private var currentIndex: Int = 0
    private let rowsCount: CGFloat = 6.0
    
    private lazy var cellSize: CGSize = {
        let padding = (StyleGuide.CalendarDatePicker.collectionMargins * 2) + (StyleGuide.CalendarDatePicker.cellsInterItemSpacing * (StyleGuide.CalendarDatePicker.cellPerRowCount - 1))
        let availableWidthForCells = UIView.globalSafeAreaFrame.width - padding
        let cellWidth = availableWidthForCells / StyleGuide.CalendarDatePicker.cellPerRowCount
            
        return CGSize(width: cellWidth, height: cellWidth)
    }()
    
    private lazy var collectionHeight: CGFloat = cellSize.height * rowsCount + StyleGuide.CalendarDatePicker.cellsInterItemSpacing * (rowsCount - 1) + StyleGuide.CalendarDatePicker.collectionMargins * 2
    
    private lazy var viewHeight = collectionHeight
    
    init(date: Date) {
        self.selectedDate = date
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        super.init(frame: .zero, collectionViewLayout: layout)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}

extension CalendarCollectionView {
    private func setup() {
        isScrollEnabled = true
        isPagingEnabled = true
        showsVerticalScrollIndicator = false
        contentInsetAdjustmentBehavior = .never
        backgroundColor = .white
        
        register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: CalendarCollectionViewCell.className)
        
        delegate = self
        dataSource = self
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout

        let collectionInset = StyleGuide.CalendarDatePicker.collectionMargins
        layout.sectionInset = UIEdgeInsets(top: collectionInset, left: collectionInset, bottom: collectionInset, right: collectionInset)
        layout.minimumLineSpacing = StyleGuide.CalendarDatePicker.cellsInterItemSpacing
        layout.minimumInteritemSpacing = StyleGuide.CalendarDatePicker.cellsInterItemSpacing
        
        frame.size = CGSize(width: UIView.globalSafeAreaFrame.width, height: viewHeight)
    }
    
    private func bindViewModel() {
        viewModel?.outputs.focusDate.bind { [weak self] date in
            self?.scrollToDate(date: date)
        }
    }
    
    func scrollToDate(date: Date? = nil) {
        
        viewModel?.inputs.selectCurrentDay()
        
        let dateToScroll = date ?? Date()
        
        let dateComponents = Calendar.current.taskCalendar.dateComponents([.year, .month], from: dateToScroll)
        if let year = dateComponents.year, let month = dateComponents.month {
            let pageIndex = viewModel?.outputs.calendarData.firstIndex(where: {
                $0.year == year && $0.month == month
            })
            
            if let pageIndex = pageIndex {
                if visibleCells.isEmpty { return }
                
                if currentIndex != pageIndex {
                    scrollToItem(at: IndexPath(row: 0, section: pageIndex), at: .top, animated: false)
                }
                
                if let monthViewModel = viewModel?.outputs.calendarData[pageIndex] {
                    viewModel?.inputs.setSelectedMonth(monthViewModel: monthViewModel)
                }
            }
        }
        
    }
}

extension CalendarCollectionView: UICollectionViewDelegate {
    
}

extension CalendarCollectionView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(round(contentOffset.y / frame.size.height))
        
        if currentIndex != index {
            currentIndex = index
            if let monthViewModel = viewModel?.outputs.calendarData[index] {
                viewModel?.inputs.setSelectedMonth(monthViewModel: monthViewModel)
            }
        }
    }
}

extension CalendarCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let dayViewModel = viewModel?.outputs.calendarData[indexPath.section].days[indexPath.row] {
            if dayViewModel.outputs.isWithinDisplayedMonth {
                viewModel?.inputs.setSelectedDay(dayViewModel: dayViewModel)
            }
        }
    }
}

extension CalendarCollectionView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.outputs.calendarData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.outputs.calendarData[section].days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.className, for: indexPath) as! CalendarCollectionViewCell
        
        cell.viewModel = viewModel?.outputs.calendarData[indexPath.section].days[indexPath.row]
        
        return cell
    }
}
