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
    private weak var localizeService: LocalizeServiceType? = AppDI.resolve()
    
    var localizableString: LocalizableStringResource? {
        didSet {
            guard let localizableString = localizableString, let localizeService = localizeService else {
                setValue("", forKey: "text")
                return
            }
            
            localizeKey = localizableString.key
            setValue(localizeService.localizeString(forKey: localizableString.key), forKey: "text")
        }
    }
    
    @available(*, unavailable, renamed: "localizableString", message: "new type: Rswift.StringResource?")
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
    
}

extension LocalizableLabel: LocalizableEntity {
    func subscribe() {
        if let localizeService = localizeService {
            localizeService.subscribe(subscriber: self) { [unowned self] locale in
                guard let localizeKey = self.localizeKey else { return }
                self.setValue(localizeService.localizeString(forKey: localizeKey), forKey: "text")
            }
        }
    }
}

