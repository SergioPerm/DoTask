//
//  CalendarPickerViewController.swift
//  ToDoList
//
//  Created by kluv on 06/09/2020.
//  Copyright © 2020 com.kluv.itotdel. All rights reserved.
//
import UIKit

class CalendarPickerViewController: UIViewController, CalendarPickerViewType {
   
    var presentableControllerViewType: PresentableControllerViewType
    var router: RouterType?
    var persistentType: PersistentViewControllerType?
    
    // MARK: ViewModel
    
    let viewModel: CalendarPickerViewModelType
        
    // MARK: Views
    
    private lazy var globalFrame = UIView.globalSafeAreaFrame
    private lazy var viewWidth: CGFloat = globalFrame.width * StyleGuide.CalendarDatePicker.ratioToScreenWidth
    private lazy var viewHeight = collectionHeight + panelHeight * panelsCount
    private lazy var panelHeight = collectionHeight * StyleGuide.CalendarDatePicker.ratioPanelToCollection
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
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        
        return collectionView
    }()
    
    // MARK: CollectionView values
    
    private let rowCount: CGFloat = 6.0
    private var indexOfCellBeforeDragging = 0
    
    private lazy var cellSize: CGSize = {
        let padding = (StyleGuide.CalendarDatePicker.collectionMargins * 2) + (StyleGuide.CalendarDatePicker.cellsInterItemSpacing * (StyleGuide.CalendarDatePicker.cellPerRowCount - 1))
        let availableWidthForCells = viewWidth - padding
        var cellWidth = availableWidthForCells / StyleGuide.CalendarDatePicker.cellPerRowCount
        cellWidth = floor(cellWidth * 10.0) / 10.0
        
        return CGSize(width: cellWidth, height: cellWidth)
    }()

    private lazy var collectionHeight: CGFloat = cellSize.height * rowCount + StyleGuide.CalendarDatePicker.cellsInterItemSpacing * (rowCount - 1) + StyleGuide.CalendarDatePicker.collectionMargins * 2
    
    private var selectedCell: CalendarPickerViewCell? {
        didSet {
            guard let selectedCell = selectedCell else { return }
            selectedCell.day?.isSelected = true
            
            guard let oldSelectedCell = oldValue else { return }
            oldSelectedCell.day?.isSelected = false
        }
    }
            
    private let calendar = Calendar.current.taskCalendar
    
    // MARK: CalendarPickerViewType
    
    var cancelDatePickerHandler: (() -> Void)?
    var saveDatePickerHandler: (() -> Void)?
    var selectedDateChangedHandler: ((Date?) -> Void)?
    
    func setSelectDay(date: Date?) {
        guard let date = date else { return }
        viewModel.inputs.setSelectedDay(date: date)
    }
    
    // MARK: Initializers
    
    init(viewModel: CalendarPickerViewModelType, router: RouterType?, presentableControllerViewType: PresentableControllerViewType) {
        self.router = router
        self.presentableControllerViewType = presentableControllerViewType
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.inputs.calculateDays()
        bindViewModel()
        setupView()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let selectedDate = viewModel.outputs.selectedDate.value ?? Date()
        let diffAmountMonths = selectedDate.endOfMonth.months(from: Date())

        setDataForHeaderView(for: viewModel.outputs.days.value[diffAmountMonths].firstDay)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
           
        //Scroll to selected month
        let selectedDate = viewModel.outputs.selectedDate.value ?? Date()
        let diffAmountMonths = selectedDate.endOfMonth.months(from: Date())
        let currentIndexPath = IndexPath(row: 0, section: diffAmountMonths)
        collectionView.scrollToItem(at: currentIndexPath, at: .centeredVertically, animated: true)
    }
    
    //MARK: Actions
    
    @objc func cancelAction(sender: UIButton) {
        if let cancelAction = cancelDatePickerHandler {
            cancelAction()
        }
        router?.pop(vc: self)
    }
    
    @objc func saveAction(sender: UIButton) {
        if let saveAction = saveDatePickerHandler {
            saveAction()
        }
        router?.pop(vc: self)
    }
    
    @objc func clearDateAction(sender: UIButton) {
        if var selectedDay = selectedCell?.day {
            selectedDay.isSelected = false
            selectedCell?.day = selectedDay
        }
        viewModel.inputs.clearSelectedDay()
        if let changeDateAction = selectedDateChangedHandler {
            changeDateAction(viewModel.outputs.selectedDate.value)
        }
    }
}

//MARK: - Bind viewModel
extension CalendarPickerViewController {
    private func bindViewModel() {
        self.viewModel.outputs.days.bind { [weak self] _ in
            self?.collectionView.reloadData()
        }
        
        self.viewModel.outputs.selectedDate.bind { [weak self] selectedDate in
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
    }
}

//MARK: - Setup and show View
extension CalendarPickerViewController {
    private func setupView() {
        //main view
        guard let mainView = UIView.globalView else { return }
        let viewOriginAtMainView = CGPoint(x: (globalFrame.width - viewWidth)/2, y: (globalFrame.height - viewHeight)/2)
        let viewOriginDiffrence = mainView.convert(viewOriginAtMainView, to: view)
        let origin = CGPoint(x: view.frame.origin.x + viewOriginDiffrence.x, y: view.frame.origin.y + viewOriginDiffrence.y)
        
        view.frame.origin = origin
        
        view.backgroundColor = R.color.datePicker.background()
        
        view.layer.cornerRadius = StyleGuide.CalendarDatePicker.viewCornerRadius
        view.clipsToBounds = true
        
        //Header view
        view.addSubview(headerView)
        
        //Collectiob view
        collectionView.register(UINib.init(nibName: "CalendarPickerViewCell", bundle: nil), forCellWithReuseIdentifier: CalendarPickerViewCell.reuseIdentifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
                
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout

        let collectionInset = StyleGuide.CalendarDatePicker.collectionMargins
        layout.sectionInset = UIEdgeInsets(top: collectionInset, left: collectionInset, bottom: collectionInset, right: collectionInset)
        layout.minimumLineSpacing = StyleGuide.CalendarDatePicker.cellsInterItemSpacing
        layout.minimumInteritemSpacing = StyleGuide.CalendarDatePicker.cellsInterItemSpacing

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
            footerView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: panelHeight * 2)
        ])
        
        NSLayoutConstraint.activate(constraints)
        
        view.frame.size = CGSize(width: self.viewWidth, height: viewHeight)
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
        return viewModel.outputs.days.value[section].days.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.outputs.days.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let day = viewModel.outputs.days.value[indexPath.section].days[indexPath.row]
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
        if day.isWithinDisplayedMonth && !day.pastDate {
            if let changeDateAction = selectedDateChangedHandler {
                changeDateAction(day.date)
            }
            viewModel.inputs.setSelectedDay(date: day.date)
              
            if cell != selectedCell {
                selectedCell = cell
            }
        }
    }
}

extension CalendarPickerViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = Int(collectionView.contentOffset.y / collectionView.frame.size.height)
        
        if (collectionView.contentOffset.y / collectionView.frame.size.height) == CGFloat(index) {
            setDataForHeaderView(for: viewModel.outputs.days.value[index].firstDay)
        }
    }
}
