//
//  TimePickerViewController.swift
//  ToDoList
//
//  Created by kluv on 16/09/2020.
//  Copyright © 2020 com.kluv.itotdel. All rights reserved.
//

import UIKit

enum TimeComponent: Int {
    case hour
    case separator
    case minute
    
    static var allCases: [TimeComponent] {
        return [.hour, .separator, .minute]
    }
    
    func currentValue() -> Int {
        return self.rawValue
    }
    
    @available(*, unavailable)
    case all
}

class TimePickerViewController: UIViewController, PresentableController {
    
    var presentableControllerViewType: PresentableControllerViewType
    var presenter: PresenterController?
    
    // MARK: View's
    
    private lazy var timePickerView: UIView = {
        let timePickerView = UIView()
        
        return timePickerView
    }()
    
    private var timePicker: UIPickerView = UIPickerView()
    
    // MARK: Properties
            
    private var baseTime: Date
    private var selectedDate:(day:Date, hour:Int, minute:Int)
    
    private let dateFormatter = DateFormatter()
    private let numberFormatter = NumberFormatter()
    
    private var hours:[Int] = []
    private var minutes:[Int] = []
    
    // MARK: Handlers
    
    var deleteReminderHandler: (() -> Void)?
    var setReminderHandler: ((_ setTime: Date) -> Void)?
    
    // MARK: Initializers
    
    init(baseTime: Date?, presenter: PresenterController?, presentableControllerViewType: PresentableControllerViewType) {
        
        self.presenter = presenter
        self.presentableControllerViewType = presentableControllerViewType
        
        self.baseTime = baseTime ?? Date()
        
        selectedDate.day = baseTime ?? Date()
        selectedDate.hour = 0
        selectedDate.minute = 0
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Life-Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setUpPickerData()
    }
                
    override func viewDidAppear(_ animated: Bool) {
        fixPickerColors()
        showView()
    }
    
    // MARK: Setup VIEW
    
    private func fixPickerColors() {
        if #available(iOS 14.0, *), let frontPickerView = timePicker.subviews.last {
            frontPickerView.backgroundColor = .clear
        }
    }
    
    private func showView() {
        let scale = StyleGuide.TimePicker.scaleShowAnimationValue
        self.view.transform = CGAffineTransform(scaleX: scale, y: scale)
        self.view.alpha = StyleGuide.TimePicker.alphaShowAnimationValue
        
        view.isHidden = false
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
                        self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        self.view.alpha = 1.0
                       }, completion: nil)
    }
    
    private func setupView() {
        guard let mainView = UIView.globalView else { return }
        
        let safeAreaFrame = UIView.globalSafeAreaFrame
        let viewWidth = safeAreaFrame.width * StyleGuide.TimePicker.ratioToScreenWidth
        let viewHeight = safeAreaFrame.height * StyleGuide.TimePicker.ratioToScreenHeight
                
        let viewOriginAtMainView = CGPoint(x: (safeAreaFrame.width - viewWidth)/2, y: (safeAreaFrame.height - viewHeight)/2)
        
        let viewOriginDifference = mainView.convert(viewOriginAtMainView, to: view)
        let viewOrigin = CGPoint(x: view.frame.origin.x + (safeAreaFrame.width - viewWidth)/2, y: view.frame.origin.y + viewOriginDifference.y)
        
        view.frame = CGRect(origin: viewOrigin, size: CGSize(width: viewWidth, height: viewHeight))
                
        view.layer.backgroundColor = Color.whiteColor.uiColor.cgColor
        view.layer.cornerRadius = StyleGuide.TimePicker.viewCornerRadius
        
        timePicker.frame = CGRect(x: 0, y: viewHeight/2, width: viewWidth, height: viewWidth)
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        timePicker.setValue(Color.clearColor.uiColor, forKey: "magnifierLineColor")
        
        timePicker.delegate = self
        timePicker.dataSource = self
        
        view.addSubview(timePicker)
                        
        let stackViewButtons = UIStackView()
        stackViewButtons.translatesAutoresizingMaskIntoConstraints = false
        
        let btnCancel = UIButton().title("Delete").autolayout(true).font(Font.timePickerBtnFont.uiFont)
        btnCancel.addTarget(self, action: #selector(deleteAction(sender:)), for: .touchUpInside)
        
        let btnSet = UIButton().title("Set").autolayout(true).font(Font.timePickerBtnFont.uiFont)
        btnSet.addTarget(self, action: #selector(setAction(sender:)), for: .touchUpInside)
        
        stackViewButtons.addArrangedSubview(btnCancel)
        stackViewButtons.addArrangedSubview(btnSet)
        
        stackViewButtons.axis = .horizontal
        stackViewButtons.alignment = .fill
        stackViewButtons.distribution = .fillEqually
        
        view.addSubview(stackViewButtons)
        
        var constraints = [
            timePicker.topAnchor.constraint(equalTo: view.topAnchor),
            timePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            timePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            timePicker.bottomAnchor.constraint(equalTo: stackViewButtons.topAnchor)
        ]
        
        constraints.append(contentsOf: [
            stackViewButtons.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackViewButtons.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackViewButtons.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackViewButtons.heightAnchor.constraint(equalToConstant: StyleGuide.TimePicker.ratioPanelToViewHeight * viewHeight)
        ])
        
        NSLayoutConstraint.activate(constraints)
        
        view.isHidden = true
    }
        
    // MARK: Calculate time data
    
    ////Normalize base time and current picker time
    private func setUpPickerData() {
        numberFormatter.formatWidth = 2
        numberFormatter.paddingPosition = .beforePrefix
        numberFormatter.paddingCharacter = "0"
        
        let currentDateComponents = Calendar.current.dateComponents([.hour, .minute], from: baseTime )
        
        guard let hour = currentDateComponents.hour, let minute = currentDateComponents.minute else { return }
        
        minutes = setupMinutes(startingMinute: minute, interval: 5)
        
        var startingHour = hour
        if minutes[0] < minute {
            startingHour += 1
        }
        
        hours = setupHours(startingHour: startingHour)
        
        selectedDate.day = Calendar.current.startOfDay(for: baseTime)
        selectedDate.hour = hours[0]
        selectedDate.minute = minutes[0]
        
//        guard let indexHour = hours.firstIndex(of: selectedDate.hour), let indexMinute = minutes.firstIndex(of: selectedDate.minute) else { return }
//
//        timePicker.selectRow(indexHour, inComponent: 0, animated: false)
//        timePicker.selectRow(indexMinute, inComponent: 2, animated: false)
        
        //normalize baseTime
        baseTime = dateFromSelectedDate() ?? baseTime
    }
    
    private func setupHours(startingHour:Int) -> [Int] {
        var result:[Int] = []
        
        for i in 0..<24 {
            let value = (startingHour + i) % 24
            result.append(value)
        }
        
        return result
    }
    
    private func setupMinutes(startingMinute:Int, interval:Int = 1) -> [Int] {
        var result:[Int] = []
        
        let count = Int(60.0 / Double(interval))
                
        for i in 0..<count {
            let value = ((Int(ceil(Double(startingMinute) / Double(interval))) + i) * interval) % 60
            result.append(value)
        }
        
        return result
    }
    
    private func dateFromSelectedDate() -> Date? {
        if let date = Calendar.current.date(bySettingHour: selectedDate.hour, minute: selectedDate.minute, second: 0, of: selectedDate.day) {
            return date
        }
        
        return nil
    }
    
    // MARK: Actions
    @objc func deleteAction(sender: UIButton) {
        if let deleteReminderAction = deleteReminderHandler {
            deleteReminderAction()
        }
        presenter?.pop(vc: self)
    }
    
    @objc func setAction(sender: UIButton) {
        if let setAction = setReminderHandler {
            setAction(baseTime)
        }
        presenter?.pop(vc: self)
    }
    
}

// MARK: UIPickerViewDataSource

extension TimePickerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return TimeComponent.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch TimeComponent.init(rawValue: component) {
        case .hour:
            return Int(Int16.max)
        case .separator:
            return 1
        case .minute:
            return Int(Int16.max)
        default:
            return 0
        }
    }
}

// MARK: UIPickerViewDelegate

extension TimePickerViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return StyleGuide.TimePicker.pickerRowHeightComponent
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return StyleGuide.TimePicker.pickerWidthComponent
    }
    
    func getTextForComponentFromRow(timeComponent: TimeComponent, row: Int) -> String {
        switch timeComponent {
        case .hour:
            guard let textComponent = numberFormatter.string(from: NSNumber(value: hours[row % hours.count])) else { return "" }
            return "\(textComponent)"
        case .separator:
            return ":"
        case .minute:
            guard let textComponent = numberFormatter.string(from: NSNumber(value: minutes[row % hours.count])) else { return "" }
            return "\(textComponent)"
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.textColor = StyleGuide.TimePicker.pickerTextColor
        
        if let timeComponent = TimeComponent.init(rawValue: component) {
            pickerLabel.text = getTextForComponentFromRow(timeComponent: timeComponent, row: row)
        }
        
        pickerLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 50)
        pickerLabel.textAlignment = NSTextAlignment.center
       
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let column = TimeComponent.init(rawValue: component) {
            switch column {
            case .hour:
                selectedDate.hour = hours[row % hours.count]
            case .minute:
                selectedDate.minute = minutes[row % minutes.count]
            default:
                return
            }
        }
        
        //normalize baseTime
        baseTime = dateFromSelectedDate() ?? baseTime
    }
}
