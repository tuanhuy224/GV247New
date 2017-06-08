//
//  GlamError.swift
//  GV24
//
//  Created by admin on 5/24/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
struct Error{
    var errorCode:Int
    var errorContent:String
    init() {
        self.errorCode = 0
        self.errorContent = "nil"
    }
    init?(JSON: [String : AnyObject]) {
        guard let codeError = JSON["code"] as? String else {return nil}
        guard let contentError = JSON["content"] as? String else {return nil}
        
        self.errorCode = Int(codeError) ?? 0
        self.errorContent = contentError
    }
}
