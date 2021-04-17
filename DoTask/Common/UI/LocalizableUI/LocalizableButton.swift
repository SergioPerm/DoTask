//
//  LocalizableButton.swift
//  DoTask
//
//  Created by Сергей Лепинин on 12.04.2021.
//  Copyright © 2021 itotdel. All rights reserved.
//

import UIKit

class LocalizableButton: UIButton {

    private var localizeKey: String?
        
    private weak var localizeService: LocalizeServiceType? = AppDI.resolve()
    
    var localizableString: LocalizableStringResource? {
        didSet {
            guard let localizableString = localizableString, let localizeService = localizeService else {
                setTitle("", for: .normal)
                return
            }
            
            localizeKey = localizableString.key
            setTitle(localizeService.localizeString(forKey: localizableString.key, locale: ""), for: .normal)
        }
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

extension LocalizableButton: LocalizableEntity {
    func subscribe() {
        if let localizeService = localizeService {
            localizeService.subscribe(subscriber: self) { [unowned self] locale in
                guard let localizeKey = self.localizeKey else { return }
                self.setTitle(localizeService.localizeString(forKey: localizeKey, locale: locale), for: .normal)
            }
        }
    }
}
