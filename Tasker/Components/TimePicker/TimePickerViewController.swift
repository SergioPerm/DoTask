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

class TimePickerViewController: UIViewController {
        
    // MARK: Properties
    
    private lazy var timePickerView: UIView = {
        let timePickerView = UIView()
        
        return timePickerView
    }()
        
    private var timePicker: UIPickerView
    private var baseTime: Date
        
    public var selectedDate:(day:Date, hour:Int, minute:Int)
    
    private let dateFormatter = DateFormatter()
    private let numberFormatter = NumberFormatter()
    
    private var hours:[Int] = []
    private var minutes:[Int] = []
    
    //private var selectedTimeChanged: ((Date?) -> Void)
    private var deleteReminderHandler: (_ vc: TimePickerViewController) -> Void
    private var setReminderHandler: (_ vc: TimePickerViewController, _ setTime: Date) -> Void
    
    // MARK: Initializers
    
    init(baseTime: Date?, onDelete deleteReminderHandler: @escaping (_ vc: TimePickerViewController) -> Void, onSet setReminderHandler: @escaping (_ vc: TimePickerViewController, _ setTime: Date) -> Void) {
        self.baseTime = baseTime ?? Date()
        self.timePicker = UIPickerView()
        
        self.deleteReminderHandler = deleteReminderHandler
        self.setReminderHandler = setReminderHandler
        
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
        showView()
    }
    
    // MARK: Setup VIEW
    
    private func showView() {
        let mainView = UIView.globalView
        
        let safeAreaGuide = getSafeAreaLayoutGuide()
        let viewWidth = safeAreaGuide.layoutFrame.width - 40
        let viewHeight = safeAreaGuide.layoutFrame.height * 0.7
        
        let viewOriginAtMainView = CGPoint(x: (safeAreaGuide.layoutFrame.width - viewWidth)/2, y: (safeAreaGuide.layoutFrame.height - viewHeight)/2)
        
        let viewOriginDifference = mainView!.convert(viewOriginAtMainView, to: view)
        let viewOrigin = CGPoint(x: view.frame.origin.x + 20, y: view.frame.origin.y + viewOriginDifference.y - safeAreaGuide.layoutFrame.width)
        
        view.frame = CGRect(origin: viewOrigin, size: CGSize(width: viewWidth, height: viewHeight))
        
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: .curveLinear,
                       animations: {
                        self.view.frame.origin = CGPoint(x: self.view.frame.origin.x, y: self.view.frame.origin.y + safeAreaGuide.layoutFrame.width)
        }, completion: nil)
    }
    
    private func setupView() {
                        
        let safeAreaGuide = getSafeAreaLayoutGuide()
        let viewWidth = safeAreaGuide.layoutFrame.width - 40
        let viewHeight = safeAreaGuide.layoutFrame.height * 0.7
                
        view.frame = CGRect(origin: CGPoint(x: 0, y: -safeAreaGuide.layoutFrame.height), size: CGSize(width: viewWidth, height: viewHeight))//CGRect(x: viewOrigin.x, y: viewOrigin.y, width: viewWidth, height: viewHeight)
        
        view.layer.backgroundColor = Color.whiteColor.uiColor.cgColor
        view.layer.cornerRadius = 8
        
        timePicker.frame = CGRect(x: 0, y: (viewHeight-viewWidth)/2, width: viewWidth, height: viewWidth)
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        timePicker.setValue(Color.clearColor.uiColor, forKey: "magnifierLineColor")
        
        timePicker.delegate = self
        timePicker.dataSource = self
        
        view.addSubview(timePicker)
        
        var constraints = [
            timePicker.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            timePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            timePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            timePicker.heightAnchor.constraint(equalToConstant: 300)
        ]
                
        let stackViewButtons = UIStackView()
        stackViewButtons.translatesAutoresizingMaskIntoConstraints = false
        
        let btnCancel = UIButton(type: .system)
        btnCancel.setTitle("Delete", for: .normal)
        btnCancel.setTitleColor(.black, for: .normal)
        btnCancel.translatesAutoresizingMaskIntoConstraints = false
        btnCancel.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 17)
        btnCancel.addTarget(self, action: #selector(deleteAction(sender:)), for: .touchUpInside)
        
        let btnSave = UIButton(type: .system)
        btnSave.setTitle("Set", for: .normal)
        btnSave.setTitleColor(.black, for: .normal)
        btnSave.translatesAutoresizingMaskIntoConstraints = false
        btnSave.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 17)
        btnSave.addTarget(self, action: #selector(setAction(sender:)), for: .touchUpInside)
        
        stackViewButtons.addArrangedSubview(btnCancel)
        stackViewButtons.addArrangedSubview(btnSave)
        
        stackViewButtons.axis = .horizontal
        stackViewButtons.alignment = .fill
        stackViewButtons.distribution = .fillEqually
        
        view.addSubview(stackViewButtons)
        
        constraints.append(contentsOf: [
            stackViewButtons.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackViewButtons.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackViewButtons.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackViewButtons.heightAnchor.constraint(equalToConstant: 75)
        ])
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    private func getSafeAreaLayoutGuide() -> UILayoutGuide {
        
        var safeAreaGuide = UILayoutGuide()
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.windows[0]
            //window.convert(<#T##point: CGPoint##CGPoint#>, to: <#T##UIView?#>)
            safeAreaGuide = window.safeAreaLayoutGuide
        }
        
        return safeAreaGuide
        
    }
    
    // MARK: Calculate time data
    
    ////Normalize base time and current picker time
    private func setUpPickerData() {
        numberFormatter.formatWidth = 2
        numberFormatter.paddingPosition = .beforePrefix
        numberFormatter.paddingCharacter = "0"
        
        let currentDateComponents = Calendar.current.dateComponents([.hour, .minute], from: baseTime )
        
        minutes = setupMinutes(startingMinute: currentDateComponents.minute!, interval: 5)
        
        if minutes[0] < currentDateComponents.minute! {
            hours = setupHours(startingHour: currentDateComponents.hour! + 1)
        } else {
            hours = setupHours(startingHour: currentDateComponents.hour!)
        }
        
        selectedDate.day = Calendar.current.startOfDay(for: baseTime)
        selectedDate.hour = hours[0]
        selectedDate.minute = minutes[0]
        
        let indexHour = hours.firstIndex(of: selectedDate.hour)
        
        timePicker.selectRow(indexHour!, inComponent: 0, animated: false)

        let indexMinute = minutes.firstIndex(of: selectedDate.minute)
        
        timePicker.selectRow(indexMinute!, inComponent: 2, animated: false)
        
        baseTime = Calendar.current.date(bySettingHour: selectedDate.hour, minute: selectedDate.minute, second: 0, of: baseTime) ?? baseTime
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
    
    private func currentSelectedDate() -> Date? {
        if let date = Calendar.current.date(bySettingHour: selectedDate.hour, minute: selectedDate.minute, second: 0, of: selectedDate.day) {
            return date
        }
        
        return nil
    }
    
    // MARK: Actions
    @objc func deleteAction(sender: UIButton) {
        deleteReminderHandler(self)
    }
    
    @objc func setAction(sender: UIButton) {
        setReminderHandler(self, baseTime)
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
        return 100
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 60
    }
    
    func getTextForComponentFromRow(timeComponent: TimeComponent, row: Int) -> String {
        switch timeComponent {
        case .hour:
            return "\(numberFormatter.string(from: NSNumber(value: hours[row % hours.count]))!)"
        case .separator:
            return ":"
        case .minute:
            return "\(numberFormatter.string(from: NSNumber(value: minutes[row % minutes.count]))!)"
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.textColor = #colorLiteral(red: 0.2369126672, green: 0.6231006994, blue: 1, alpha: 1)
        
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
        
        if let date = currentSelectedDate() {
            baseTime = date
        }
    }
}
