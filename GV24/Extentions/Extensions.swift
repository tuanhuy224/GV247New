//
//  Extensions.swift
//  GV24
//
//  Created by Macbook Solution on 7/4/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation

extension Locale {
    
    func IOSLanguageCode() -> String? {
        guard let languageCode = languageCode, let countryCode = countryCode else {
            return nil
        }
        return "\(languageCode)-\(countryCode)"
    }
    
}
