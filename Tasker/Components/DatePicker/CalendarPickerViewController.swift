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
    
    private lazy var cellSize: CGSize = {
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let padding = (collectionMargins * 2) + (cellsInterInsets * (cellPerRowCount - 1))
        let availableWidthForCells = viewWidth! - padding
        let cellWidth = availableWidthForCells / cellPerRowCount
            
        return CGSize(width: cellWidth, height: cellWidth)
    }()
    
    let cellsInterInsets: CGFloat = 5.0
    let cellPerRowCount: CGFloat = 7.0
    let collectionMargins: CGFloat = 20.0
    
    var viewWidth: CGFloat?
    
    private var indexOfCellBeforeDragging = 0
    
    private func setupView() {
        
        //main view
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        let safeLayoutGuide = getSafeAreaLayoutGuide()
        viewWidth = safeLayoutGuide.layoutFrame.width - 40
        view.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: .zero)
        let viewOrigin = CGPoint(x: (safeLayoutGuide.layoutFrame.width - viewWidth!)/2, y: 20)
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
                
        //Header view
        view.addSubview(headerView)
        
        //Collection view
        let collectionheight = cellSize.width * 6 + cellsInterInsets * 5 + collectionMargins * 2
        
        let panelHeight = viewWidth!/(280/50)//280 / 50
        
        let viewHeight = collectionheight + panelHeight * 3
        
        collectionView.register(UINib.init(nibName: "CalendarPickerViewCell", bundle: nil), forCellWithReuseIdentifier: CalendarPickerViewCell.reuseIdentifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
                
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
  
        layout.sectionInset = UIEdgeInsets(top: collectionMargins, left: collectionMargins, bottom: collectionMargins, right: collectionMargins)
        layout.minimumLineSpacing = cellsInterInsets
        layout.minimumInteritemSpacing = cellsInterInsets

        view.addSubview(collectionView)

        
        //Footer view
        view.addSubview(footerView)
        
        var constraints = [
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: panelHeight)
        ]
                
        constraints.append(contentsOf: [
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0),
            collectionView.heightAnchor.constraint(equalToConstant: collectionheight)
        ])
        
        constraints.append(contentsOf: [
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 0),
            footerView.heightAnchor.constraint(equalToConstant: panelHeight * 2)
        ])
        
        NSLayoutConstraint.activate(constraints)
        
        view.frame = CGRect(origin: viewOrigin, size: CGSize(width: self.viewWidth!, height: viewHeight))
        view.isHidden = true

    }
    
    private func showView() {
        let mainView = view.globalView
        
        let safeAreaGuide = getSafeAreaLayoutGuide()
        let viewWidth = safeAreaGuide.layoutFrame.width - 40
        let viewHeight = safeAreaGuide.layoutFrame.height * 0.7
        
        let viewOriginAtMainView = CGPoint(x: (safeAreaGuide.layoutFrame.width - viewWidth)/2, y: (safeAreaGuide.layoutFrame.height - viewHeight)/2)
        
        let viewOriginDiffrence = mainView!.convert(viewOriginAtMainView, to: view)
        let viewOriginY = view.frame.origin.y + viewOriginDiffrence.y
        
        let startViewOrigin = viewOriginY - (mainView!.frame.height + viewOriginAtMainView.y)
        
        view.frame.origin = CGPoint(x: view.frame.origin.x, y: startViewOrigin)
        view.isHidden = false
        
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: .curveLinear,
                       animations: {
                        self.view.frame.origin = CGPoint(x: self.view.frame.origin.x, y: viewOriginY)
        }, completion: nil)
    }
    
    private func getSafeAreaLayoutGuide() -> UILayoutGuide {
        
        var safeAreaGuide = UILayoutGuide()
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.windows[0]
            safeAreaGuide = window.safeAreaLayoutGuide
        }
        
        return safeAreaGuide
        
    }
   
    var cancelDatePickerHandler: (_ vc:CalendarPickerViewController) -> Void
    var saveDatePickerHandler: (_ vc:CalendarPickerViewController) -> Void
    
    // MARK: Calendar Data Values
    
    private var selectedCell: CalendarPickerViewCell? {
        didSet {
            selectedCell!.day?.isSelected = true
            selectedCell!.updateVisibleStatus()
            oldValue?.day?.isSelected = false
            oldValue?.updateVisibleStatus()
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

            let day = numberFormatter.string(from: dateComponents as NSNumber)
            let dateFormatter = DateFormatter()

            dateFormatter.dateFormat = "MMMM"

            let dateString = "\(dateFormatter.string(from: selectedDate)) \(day!)"

            footerView.currentDateLabel.text = dateString
            footerView.clearDateButton.isHidden = false
        }
    }

    private var baseDate: Date {
      didSet {
        days = generateDaysForThreeYears(for: baseDate)
        collectionView.reloadData()
      }
    }
    
    private lazy var days = generateDaysForThreeYears(for: baseDate)
    
    private let selectedDateChanged: (Date?) -> Void
    
    private let calendar = Calendar(identifier: .iso8601)
    
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
            alignMonthInCollectionView()
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
        let weekDay = calendar.component(.weekday, from: weekdayDate)
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
        headerView.monthYearLabel.text = dateFormatter.string(from: currentDate)
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
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: collectionMargins, left: collectionMargins, bottom: collectionMargins, right: collectionMargins)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CalendarPickerViewCell
        if cell == selectedCell {
            return
        }
        
        let day = cell.day
                         
        if day!.isWithinDisplayedMonth {
            selectedDateChanged(day!.date)
            selectedDate = day!.date
            selectedCell = cell
        }
    }
}

//MARK: - UICollectionViewDelegate

extension CalendarPickerViewController: UICollectionViewDelegate {

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        indexOfCellBeforeDragging = indexOfMajorCell()
    }

    private func indexOfMajorCell() -> Int {
        let sectionHeight = (collectionMargins * 2) + (cellSize.height * 6) + (cellsInterInsets * 5)
        let proportionalOffset = collectionView.contentOffset.y / sectionHeight
        let index = Int(round(proportionalOffset))
        let numberOfItems = days.count
        let safeIndex = max(0, min(numberOfItems - 1, index))
        return safeIndex
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // Stop scrollView sliding:
        targetContentOffset.pointee = scrollView.contentOffset
        alignMonthInCollectionView()
    }
    
    func alignMonthInCollectionView() {
        let velocity = CGPoint(x: 0, y: 0)
        
        let sectionHeight = (collectionMargins * 2) + (cellSize.height * 6) + (cellsInterInsets * 5)

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
                setDataForHeaderView(for: days[snapToIndex].firstDay)
                // Damping equal 1 => no oscillations => decay animation:
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.y, options: .allowUserInteraction, animations: {
                    self.collectionView.contentOffset = CGPoint(x: 0, y: toValue)
                    self.collectionView.layoutIfNeeded()
                }, completion: nil)
            }

        } else {
            setDataForHeaderView(for: days[indexOfMajorCell].firstDay)
            let offsetForSlide = CGFloat(indexOfMajorCell) * sectionHeight
            collectionView.setContentOffset(CGPoint(x: 0, y: offsetForSlide), animated: true)
        }
    }
}
