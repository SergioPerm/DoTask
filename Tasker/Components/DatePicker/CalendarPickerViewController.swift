//
//  CalendarPickerViewController.swift
//  ToDoList
//
//  Created by kluv on 06/09/2020.
//  Copyright © 2020 com.kluv.itotdel. All rights reserved.
//

import UIKit

class CalendarPickerViewController: UIViewController {
    
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
    
    private var selectedDate: Date? {
        didSet {
            guard let selectedDate = selectedDate else {
                footerView.currentDateLabel.text = "No selected date"
                footerView.clearDateButton.isHidden = true
                return
            }

            let dateComponents = calendar.component(.day, from: selectedDate)
            let numberFormatter = NumberFormatter()
            
            numberFormatter.numberStyle = .ordinal
            
            guard let day = numberFormatter.string(from: dateComponents as NSNumber) else { return }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM"
            let dateString = "\(dateFormatter.string(from: selectedDate)) \(day)"
            
            footerView.currentDateLabel.text = dateString
            footerView.clearDateButton.isHidden = false
        }
    }

    private var baseDate: Date {
      didSet {
        _ = days
        collectionView.reloadData()
      }
    }
    
    private lazy var days = generateDaysForThreeYears(for: baseDate)
    
    private let selectedDateChanged: (Date?) -> Void
    
    private let calendar = Calendar.current.taskCalendar
    
    private lazy var dateFormatter: DateFormatter = {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "d"
      return dateFormatter
    }()
    
    // MARK: Initializers

    init(baseDate: Date, selectDate: Date, onSelectedDateChanged selectedDateChangedHandler: @escaping (Date?) -> Void, onCancel cancelDatePickerHandler: @escaping (_ vc:CalendarPickerViewController) -> Void, onSave saveDatePickerHandler: @escaping (_ vc:CalendarPickerViewController) -> Void) {
        
        self.selectedDate = selectDate
        self.cancelDatePickerHandler = cancelDatePickerHandler
        self.saveDatePickerHandler = saveDatePickerHandler
        
        self.baseDate = baseDate
        self.selectedDateChanged = selectedDateChangedHandler
                        
        super.init(nibName: nil, bundle: nil)
        
        self.setSelectedDate(fromValue: selectDate)
    }

    private func setSelectedDate(fromValue: Date) {
        self.selectedDate = fromValue
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
        if let diffAmountMonths = selectedDate?.endOfMonth.months(from: baseDate) {
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
        selectedDate = nil
        selectedDateChanged(selectedDate)
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

//MARK: - Calendar calculation
extension CalendarPickerViewController {
    enum CalendarDataError: Error {
      case metadataGeneration
    }
        
    func generateDaysForThreeYears(for baseDate: Date) -> [MonthModel] {
        var yearComponent = DateComponents()
        var allMonths: [MonthModel] = []
        allMonths.removeAll()
        
        for year in 0...2 {
            yearComponent.year = year
            var yearDate = Date()
            if year == 0 {
                yearDate = baseDate
            } else {
                yearDate = calendar.date(byAdding: yearComponent, to: baseDate)!
            }
            
            let yearNum = calendar.component(.year, from: yearDate)

            var firstDayInYear = yearDate
            if year > 0 {
                firstDayInYear = calendar.date(from: DateComponents(year: yearNum, month: 1, day: 1))!
            }
            
            let monthNumber = calendar.component(.month, from: firstDayInYear)

            for month in monthNumber...12 {
                let currentMonthDate = calendar.date(from: DateComponents(year: yearNum, month: month, day: 1))!
                allMonths.append(generateMonth(for: currentMonthDate))
                //allMonths.append(generateDaysInMonth(for: currentMonthDate))
            }
            
        }
        
        return allMonths
    }
    
    func getWeekday(from weekdayDate: Date) -> Int {
        let weekDay = calendar.component(.weekday, from: weekdayDate.localDate())
        return weekDay == 1 ? 7 : weekDay - 1
    }
    
    func monthModel(from monthDate: Date) throws -> MonthModel {
        guard
            let numberOfDaysInMonth = calendar.range(of: .day, in: .month, for: monthDate)?.count,
            let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: monthDate)) else {
                throw CalendarDataError.metadataGeneration
        }
        
        let firstDayWeekday = getWeekday(from: firstDayOfMonth)
        let offsetInInitialRow = firstDayWeekday
        
        var days: [DayModel] = (1..<(numberOfDaysInMonth + offsetInInitialRow)).map { day in
            let isWithinDisplayedMonth = day >= offsetInInitialRow
            let dayOffset = isWithinDisplayedMonth ? day - offsetInInitialRow : -(offsetInInitialRow - day)
            
            return generateDay(offsetBy: dayOffset, for: firstDayOfMonth, isWithinDisplayedMonth: isWithinDisplayedMonth)
        }
        
        days += generateStartOfNextMonth(using: firstDayOfMonth, totalDays: days.count)
        
        return MonthModel(numberOfDays: numberOfDaysInMonth, firstDay: firstDayOfMonth, firstDayWeekday: firstDayWeekday, days: days)
    }
    
    func generateMonth(for monthDate: Date) -> MonthModel {
        guard let monthData = try? monthModel(from: monthDate) else {
            fatalError("An error occurred when generating the metadata for \(monthDate)")
        }
        
        return monthData
    }
    
    func generateDaysInMonth(for baseDate: Date) -> [DayModel] {
        guard let monthData = try? monthModel(from: baseDate) else {
            fatalError("An error occurred when generating the metadata for \(baseDate)")
        }
        
        let numberOfDaysInMonth = monthData.numberOfDays
        let offsetInInitialRow = monthData.firstDayWeekday
        let firstDayOfMonth = monthData.firstDay

        var days: [DayModel] = (1..<(numberOfDaysInMonth + offsetInInitialRow)).map { day in

            let isWithinDisplayedMonth = day >= offsetInInitialRow
            let dayOffset = isWithinDisplayedMonth ? day - offsetInInitialRow : -(offsetInInitialRow - day)

            return generateDay(offsetBy: dayOffset, for: firstDayOfMonth, isWithinDisplayedMonth: isWithinDisplayedMonth)
        }

        days += generateStartOfNextMonth(using: firstDayOfMonth, totalDays: days.count)
        
        return days
    }
    
    func generateStartOfNextMonth(using firstDayOfDisplayedMonth: Date, totalDays: Int) -> [DayModel] {
        guard let lastDayInMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1),to: firstDayOfDisplayedMonth) else {
            return []
        }
        
        let additionalDays = 42 - totalDays//14 - calendar.component(.weekday, from: lastDayInMonth)
               
        guard additionalDays > 0 else {
            return []
        }
                
        let days: [DayModel] = (1...additionalDays)
            .map {
                generateDay(
                    offsetBy: $0,
                    for: lastDayInMonth,
                    isWithinDisplayedMonth: false)
        }
        
        return days
    }
    
    func generateDay(offsetBy dayOffset: Int, for firstDayOfMonth: Date, isWithinDisplayedMonth: Bool) -> DayModel {
        let dayDate = calendar.date(byAdding: .day, value: dayOffset, to: firstDayOfMonth)!
        let weekDay = getWeekday(from: dayDate)

        let isCurrentDay = calendar.isDate(dayDate, equalTo: baseDate, toGranularity: .day)
        let isSelected = calendar.isDate(dayDate, equalTo: selectedDate!, toGranularity: .day)
        
        return DayModel(date: dayDate, number: dateFormatter.string(from: dayDate),
                        isSelected: isSelected,
                        isWithinDisplayedMonth: isWithinDisplayedMonth,
                        isWeekend: weekDay > 5 ? true : false,
                        currentDay: isCurrentDay)
    }
    
    func setDataForHeaderView(for currentDate: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL YYYY"
        headerView.monthYearLabel.text = dateFormatter.string(from: currentDate).capitalizingFirstLetter()
    }
}

//MARK: - UICollectionViewDataSource

extension CalendarPickerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days[section].days.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let day = days[indexPath.section].days[indexPath.row]

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
        let day = cell.day
                         
        if day!.isWithinDisplayedMonth {
            selectedDateChanged(day!.date)
            selectedDate = day!.date
            
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
        let numberOfItems = days.count
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
        let dataSourceCount = days.count
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
                    self.setDataForHeaderView(for: self.days[snapToIndex].firstDay)
                })
            }

        } else {
            let offsetForSlide = CGFloat(indexOfMajorCell) * sectionHeight
            collectionView.setContentOffset(CGPoint(x: 0, y: offsetForSlide), animated: true)
            setDataForHeaderView(for: days[indexOfMajorCell].firstDay)
        }
    }
}
