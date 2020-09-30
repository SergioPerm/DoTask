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
        
    private var selectedDate:(day:Date, hour:Int, minute:Int)
    
    private let dateFormatter = DateFormatter()
    private let numberFormatter = NumberFormatter()
    
    private var hours:[Int] = []
    private var minutes:[Int] = []
    
    private var selectedTimeChanged: ((Date?) -> Void)
    private var cancelTimePickerHandler: (_ vc: TimePickerViewController) -> Void
    private var saveTimePickerHandler: (_ vc: TimePickerViewController) -> Void
    
    // MARK: Initializers
    
    init(baseTime: Date?, onSelectedTime selectedTimeChanded: @escaping (Date?) -> Void, onCancel cancelTimePickerHandler: @escaping (_ vc: TimePickerViewController) -> Void, onSave saveTimePickerHandler: @escaping (_ vc: TimePickerViewController) -> Void) {
        self.baseTime = baseTime ?? Date()
        self.timePicker = UIPickerView()
        
        self.selectedTimeChanged = selectedTimeChanded
        self.cancelTimePickerHandler = cancelTimePickerHandler
        self.saveTimePickerHandler = saveTimePickerHandler
        
        selectedDate.day = baseTime ?? Date()
        selectedDate.hour = 0
        selectedDate.minute = 0
        
        super.init(nibName: nil, bundle: nil)
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        numberFormatter.formatWidth = 2
        numberFormatter.paddingPosition = .beforePrefix
        numberFormatter.paddingCharacter = "0"
        
        let currentDateComponents = Calendar.current.dateComponents([.hour, .minute], from: baseTime ?? Date())
        
        hours = setupHours(startingHour: currentDateComponents.hour!)
        minutes = setupMinutes(startingMinute: currentDateComponents.minute!, interval: 5)
        
        selectedDate.day = Calendar.current.startOfDay(for: baseTime ?? Date())
        selectedDate.hour = hours[0]
        selectedDate.minute = minutes[0]
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Life-Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
            
    override func viewDidAppear(_ animated: Bool) {
        let mainView = view.globalView
        
        let safeAreaGuide = getSafeAreaLayoutGuide()
        let viewWidth = safeAreaGuide.layoutFrame.width - 40
        let viewHeight = safeAreaGuide.layoutFrame.height * 0.7
        
        let viewOriginAtMainView = CGPoint(x: (safeAreaGuide.layoutFrame.width - viewWidth)/2, y: (safeAreaGuide.layoutFrame.height - viewHeight)/2)
        
        let viewOriginDifference = mainView!.convert(viewOriginAtMainView, to: view)
        let viewOrigin = CGPoint(x: view.frame.origin.x + 20, y: view.frame.origin.y + viewOriginDifference.y - safeAreaGuide.layoutFrame.width)
        
        view.frame = CGRect(origin: viewOrigin, size: CGSize(width: viewWidth, height: viewHeight))
        
        let hour = Calendar.current.component(.hour, from: baseTime)
        let min = Calendar.current.component(.minute, from: baseTime)

        let indexHour = hours.firstIndex(of: hour)
        
        timePicker.selectRow(indexHour!, inComponent: 0, animated: false)

        var minuteIndex: CGFloat = CGFloat(min/5)
        minuteIndex.round(.down)
        let roundMinutes = Int(minuteIndex) * 5

        let indexMinute = minutes.firstIndex(of: roundMinutes)
        
        timePicker.selectRow(indexMinute!, inComponent: 2, animated: false)
        
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: .curveLinear,
                       animations: {
                        self.view.frame.origin = CGPoint(x: self.view.frame.origin.x, y: self.view.frame.origin.y + safeAreaGuide.layoutFrame.width)
        }, completion: nil)
        
    }
    
    // MARK: Setup VIEW
    
    private func setupView() {
                        
        let safeAreaGuide = getSafeAreaLayoutGuide()
        let viewWidth = safeAreaGuide.layoutFrame.width - 40
        let viewHeight = safeAreaGuide.layoutFrame.height * 0.7
                
        view.frame = CGRect(origin: CGPoint(x: 0, y: -safeAreaGuide.layoutFrame.height), size: CGSize(width: viewWidth, height: viewHeight))//CGRect(x: viewOrigin.x, y: viewOrigin.y, width: viewWidth, height: viewHeight)
        
        view.layer.backgroundColor = UIColor.white.cgColor
        view.layer.cornerRadius = 8
        
        timePicker.frame = CGRect(x: 0, y: (viewHeight-viewWidth)/2, width: viewWidth, height: viewWidth)
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        timePicker.setValue(UIColor.clear, forKey: "magnifierLineColor")
        
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
    
    // MARK: Calcilate time data
    
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
            let value = ((Int(ceil(Double(startingMinute) / Double(interval))) + i + 1) * interval) % 60
            result.append(value)
        }
        
        return result
    }
    
    private func currentSelectedDate() -> Date? {
        var timeComponents = DateComponents()
        timeComponents.hour = selectedDate.hour
        timeComponents.minute = selectedDate.minute
        
        if let date = Calendar.current.date(byAdding: timeComponents, to: selectedDate.day) {
            return date
        }
        
        return nil
    }
    
    // MARK: Actions
    @objc func deleteAction(sender: UIButton) {
        //delegate?.deleteReminder()
    }
    
    @objc func setAction(sender: UIButton) {
        //delegate?.setReminderWithTime(reminderTime: baseTime)
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
