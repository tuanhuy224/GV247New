//
//  CustomLocale.swift
//  GV24
//
//  Created by HuyNguyen on 6/1/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation

class CustomLocale: NSObject {
    var name:String?
    var languageCode:String?
    var countryCode:String?
    
    init(languageCode: String,countryCode:String,name: String) {
        
        self.name = name
        self.languageCode = languageCode
        self.countryCode = countryCode
        
    }
    
}

