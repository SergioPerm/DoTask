//
//  CalendarPickerViewController.swift
//  ToDoList
//
//  Created by kluv on 06/09/2020.
//  Copyright © 2020 com.kluv.itotdel. All rights reserved.
//

import UIKit

class CalendarPickerViewController: UIViewController {
    
    // MARK: ViewModel
    let viewModel: CalendarPickerViewModelType
    
    // MARK: Views
    private lazy var globalFrame = UIView.globalSafeAreaFrame
    private lazy var viewWidth: CGFloat = globalFrame.width * StyleGuide.datePickerSpaces.ratioToScreenWidth
    private lazy var viewHeight = collectionHeight + panelHeight * panelsCount
    private lazy var panelHeight = collectionHeight * StyleGuide.datePickerSpaces.ratioPanelToCollection
    private var panelsCount: CGFloat = 3.0
        
    private lazy var headerView: CalendarPickerHeaderView = {
        let headerView = CalendarPickerHeaderView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        return headerView
    }()
    
    private lazy var footerView: CalendarPickerFooterView = {
        let footerView = CalendarPickerFooterView()
        footerView.translatesAutoresizingMaskIntoConstraints = false

        footerView.saveButton.addTarget(self, action: #selector(saveAction(sender:)), for: .touchUpInside)
        footerView.cancelButton.addTarget(self, action: #selector(cancelAction(sender:)), for: .touchUpInside)
        footerView.clearDateButton.addTarget(self, action: #selector(clearDateAction(sender:)), for: .touchUpInside)
        
        return footerView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
                
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        
        return collectionView
    }()
    
    // MARK: Scroll view values
    
    private var indexOfCellBeforeDragging = 0
    private lazy var collectionHeight: CGFloat = cellSize.height * 6 + StyleGuide.datePickerSpaces.cellsInterItemSpacing * 5 + StyleGuide.datePickerSpaces.collectionMargins * 2
    
    private lazy var cellSize: CGSize = {
        let padding = (StyleGuide.datePickerSpaces.collectionMargins * 2) + (StyleGuide.datePickerSpaces.cellsInterItemSpacing * (StyleGuide.datePickerSpaces.cellPerRowCount - 1))
        let availableWidthForCells = viewWidth - padding
        let cellWidth = availableWidthForCells / StyleGuide.datePickerSpaces.cellPerRowCount
            
        return CGSize(width: cellWidth, height: cellWidth)
    }()
               
    var cancelDatePickerHandler: (_ vc:CalendarPickerViewController) -> Void
    var saveDatePickerHandler: (_ vc:CalendarPickerViewController) -> Void
    
    // MARK: Calendar Data Values
    
    private var selectedCell: CalendarPickerViewCell? {
        didSet {
            guard let selectedCell = selectedCell else { return }
            selectedCell.day?.isSelected = true
            selectedCell.updateVisibleStatus()
            
            guard let oldSelectedCell = oldValue else { return }
            oldSelectedCell.day?.isSelected = false
            oldSelectedCell.updateVisibleStatus()
        }
    }
        
    private let selectedDateChanged: (Date?) -> Void
    
    private let calendar = Calendar.current.taskCalendar
    
    // MARK: Initializers
    
    init(selectedDate: Date,
         onSelectedDateChanged selectedDateChangedHandler: @escaping (Date?) -> Void,
         onCancel cancelDatePickerHandler: @escaping (_ vc:CalendarPickerViewController) -> Void,
         onSave saveDatePickerHandler: @escaping (_ vc:CalendarPickerViewController) -> Void) {
        
        self.viewModel = CalendarPickerViewModel(selectedDate: selectedDate)
        
        
        self.cancelDatePickerHandler = cancelDatePickerHandler
        self.saveDatePickerHandler = saveDatePickerHandler
        

        self.selectedDateChanged = selectedDateChangedHandler
        
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel.baseDate.bind { [weak self] baseDate in
            self?.collectionView.reloadData()
        }
        
        self.viewModel.selectedDate.bind { [weak self] selectedDate in
            
            guard let strongSelf = self else { return }
            guard let selectedDate = selectedDate else {
                strongSelf.footerView.currentDateLabel.text = "No selected date"
                strongSelf.footerView.clearDateButton.isHidden = true
                return
            }

            let dateComponents = strongSelf.calendar.component(.day, from: selectedDate)
            let numberFormatter = NumberFormatter()
            
            numberFormatter.numberStyle = .ordinal
            
            guard let day = numberFormatter.string(from: dateComponents as NSNumber) else { return }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM"
            let dateString = "\(dateFormatter.string(from: selectedDate)) \(day)"
            
            strongSelf.footerView.currentDateLabel.text = dateString
            strongSelf.footerView.clearDateButton.isHidden = false
        }
        
        self.viewModel.days.bind { [weak self] _ in
            self?.collectionView.reloadData()
        }
        
        self.viewModel.calculateDays()
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showView()
        
        ///Scroll to selected month
        if let diffAmountMonths = viewModel.selectedDate.value?.endOfMonth.months(from: viewModel.baseDate.value) {
            let currentIndexPath = IndexPath(row: 0, section: diffAmountMonths)
            collectionView.scrollToItem(at: currentIndexPath, at: .centeredVertically, animated: false)
            alignMonthInCollectionView(velocity: CGPoint.zero)
        }
    }
    
    //MARK: Actions
    @objc func cancelAction(sender: UIButton) {
        cancelDatePickerHandler(self)
    }
    
    @objc func saveAction(sender: UIButton) {
        saveDatePickerHandler(self)
    }
    
    @objc func clearDateAction(sender: UIButton) {
        viewModel.selectedDate.value = nil
        selectedDateChanged(viewModel.selectedDate.value)
    }
}

//MARK: - Setup and show View

extension CalendarPickerViewController {
    private func setupView() {
        //main view
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: .zero)
                
        let viewOrigin = CGPoint(x: (globalFrame.width - viewWidth)/2, y: 20)
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
                
        //Header view
        view.addSubview(headerView)
        
        //Collectiob view
        collectionView.register(UINib.init(nibName: "CalendarPickerViewCell", bundle: nil), forCellWithReuseIdentifier: CalendarPickerViewCell.reuseIdentifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
                
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout

        let collectionInset = StyleGuide.datePickerSpaces.collectionMargins
        layout.sectionInset = UIEdgeInsets(top: collectionInset, left: collectionInset, bottom: collectionInset, right: collectionInset)
        layout.minimumLineSpacing = StyleGuide.datePickerSpaces.cellsInterItemSpacing
        layout.minimumInteritemSpacing = StyleGuide.datePickerSpaces.cellsInterItemSpacing

        view.addSubview(collectionView)

        //Footer view
        view.addSubview(footerView)
        
        //Autolayout
        var constraints = [
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: panelHeight)
        ]
                
        constraints.append(contentsOf: [
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: collectionHeight)
        ])
        
        constraints.append(contentsOf: [
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 0),
            footerView.heightAnchor.constraint(equalToConstant: panelHeight * 2)
        ])
        
        NSLayoutConstraint.activate(constraints)
        
        view.frame = CGRect(origin: viewOrigin, size: CGSize(width: self.viewWidth, height: viewHeight))
        view.isHidden = true
    }
    
    private func showView() {
        guard let mainView = UIView.globalView else { return }
                
        let viewOriginAtMainView = CGPoint(x: (globalFrame.width - viewWidth)/2, y: (globalFrame.height - viewHeight)/2)
        let viewOriginDiffrence = mainView.convert(viewOriginAtMainView, to: view)
        let viewOriginY = view.frame.origin.y + viewOriginDiffrence.y
        
        self.view.frame.origin = CGPoint(x: self.view.frame.origin.x, y: viewOriginY)
         
        self.view.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        self.view.alpha = 0.3
        
        view.isHidden = false
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
                        self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        self.view.alpha = 1.0
        }, completion: nil)
    }
}

//MARK: - Common

extension CalendarPickerViewController {
    func setDataForHeaderView(for currentDate: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL YYYY"
        headerView.monthYearLabel.text = dateFormatter.string(from: currentDate).capitalizingFirstLetter()
    }
}

//MARK: - UICollectionViewDataSource

extension CalendarPickerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.days.value[section].days.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.days.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let day = viewModel.days.value[indexPath.section].days[indexPath.row]

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarPickerViewCell.reuseIdentifier, for: indexPath) as! CalendarPickerViewCell

        cell.day = day
        
        if cell.day!.isSelected {
            selectedCell = cell
        }
        
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension CalendarPickerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
            
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CalendarPickerViewCell
                  
        guard let day = cell.day else { return }
        if day.isWithinDisplayedMonth {
            selectedDateChanged(day.date)
            viewModel.selectedDate.value = day.date
            
            if cell != selectedCell {
                selectedCell = cell
            }
        }
    }
}

//MARK: - UICollectionViewDelegate

extension CalendarPickerViewController: UICollectionViewDelegate {

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        indexOfCellBeforeDragging = indexOfMajorCell()
    }

    private func indexOfMajorCell() -> Int {
        let sectionHeight = (StyleGuide.datePickerSpaces.collectionMargins * 2) + (cellSize.height * 6) + (StyleGuide.datePickerSpaces.cellsInterItemSpacing * 5)
        let proportionalOffset = collectionView.contentOffset.y / sectionHeight
        let index = Int(round(proportionalOffset))
        let numberOfItems = viewModel.days.value.count
        let safeIndex = max(0, min(numberOfItems - 1, index))
        return safeIndex
    }
        
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        targetContentOffset.pointee = scrollView.contentOffset
        alignMonthInCollectionView(velocity: velocity)
    }
        
    func alignMonthInCollectionView(velocity: CGPoint) {
        
        let sectionHeight = (StyleGuide.datePickerSpaces.collectionMargins * 2) + (cellSize.height * 6) + (StyleGuide.datePickerSpaces.cellsInterItemSpacing * 5)

        // calculate where scrollView should snap to:
        let indexOfMajorCell = self.indexOfMajorCell()

        // calculate conditions:
        let dataSourceCount = viewModel.days.value.count
        let swipeVelocityThreshold: CGFloat = 0.5 // after some trail and error
        let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < dataSourceCount && velocity.y > swipeVelocityThreshold
        let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging >= 0 && velocity.y < -swipeVelocityThreshold
        let majorCellIsTheCellBeforeDragging = indexOfMajorCell == indexOfCellBeforeDragging
        let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)

        if didUseSwipeToSkipCell {

            let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
            let toValue = sectionHeight * CGFloat(snapToIndex)

            if (snapToIndex >= 0) {
                // Damping equal 1 => no oscillations => decay animation:
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.y < 0 ? velocity.y * -1 : velocity.y, options: .allowUserInteraction, animations: {
                    self.collectionView.contentOffset = CGPoint(x: 0, y: toValue)
                    self.collectionView.layoutIfNeeded()
                }, completion: { finished in
                    self.setDataForHeaderView(for: self.viewModel.days.value[snapToIndex].firstDay)
                })
            }

        } else {
            let offsetForSlide = CGFloat(indexOfMajorCell) * sectionHeight
            collectionView.setContentOffset(CGPoint(x: 0, y: offsetForSlide), animated: true)
            setDataForHeaderView(for: viewModel.days.value[indexOfMajorCell].firstDay)
        }
    }
}
