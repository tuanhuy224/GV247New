
//
//  Process.swift
//  GV24
//
//  Created by HuyNguyen on 6/6/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import SwiftyJSON

class Process: AppModel {
    var id:String?
    var name:String?
    override init() {
        super.init()
    }
    override init(json: JSON) {
        super.init(json: json)
        self.id = json["_id"].string
        self.name = json["name"].string
    }
}
