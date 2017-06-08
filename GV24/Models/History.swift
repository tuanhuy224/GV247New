//
//  History.swift
//  GV24
//
//  Created by HuyNguyen on 6/6/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import SwiftyJSON

class History: AppModel {
    var createAt:String?
    var updateAt:String?
    override init() {
        super.init()
    }
    override init(json: JSON) {
        super.init(json: json)
        self.createAt = json["createAt"].string
        self.updateAt = json["updateAt"].string
    }

}
