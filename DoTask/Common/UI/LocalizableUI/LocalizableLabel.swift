//
//  LocalizableLabel.swift
//  DoTask
//
//  Created by Сергей Лепинин on 03.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class LocalizableLabel: UILabel {

    private var localizeKey: String?
    
    private var date: Date?
    private var dateFormat: String?
    
    private let calendar = Calendar.current.taskCalendar
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        return dateFormatter
    }()
    
    private weak var localizeService: LocalizeServiceType? = AppDI.resolve()
    
    var localizableString: LocalizableStringResource? {
        didSet {
            date = nil
            dateFormat = nil
            
            guard let localizableString = localizableString, let localizeService = localizeService else {
                setValue("", forKey: "text")
                return
            }
            
            if let staticString = localizableString.staticString {
                localizeKey = nil
                setValue(staticString, forKey: "text")
            } else {
                localizeKey = localizableString.key
                setValue(localizeService.localizeString(forKey: localizableString.key, locale: ""), forKey: "text")
            }
        }
    }
    
    @available(*, unavailable, renamed: "localizableString", message: "new type: LocalizableStringResource?")
    override var text: String? {
        didSet {}
    }
    
    init() {
        super.init(frame: .zero)
        subscribe()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        if let localizeService = localizeService {
            localizeService.unsubscribe(subscriber: self)
        }
    }
    
}

extension LocalizableLabel {
    func setDateWithFormat(date: Date?, format: String?) {
        self.date = date
        self.dateFormat = format
        
        setTextFromDate()
    }
    
    private func setTextFromDate() {
        guard let localizeService = localizeService else { return }
        guard let currentLocal = localizeService.currentLocal, let dateFormat = dateFormat, let date = date else { return }
        
        dateFormatter.locale = Locale(identifier: currentLocal.rawValue)
        dateFormatter.setLocalizedDateFormatFromTemplate(dateFormat)
        let stringDate = dateFormatter.string(from: date).capitalizingFirstLetter()
        
        setValue(stringDate, forKey: "text")
    }
}

extension LocalizableLabel: LocalizableEntity {
    func subscribe() {
        if let localizeService = localizeService {
            localizeService.subscribe(subscriber: self) { [unowned self] locale in
                if let _ = date {
                    self.setTextFromDate()
                } else {
                    guard let localizeKey = self.localizeKey else { return }
                    self.setValue(localizeService.localizeString(forKey: localizeKey, locale: locale), forKey: "text")
                }
            }
        }
    }
}




