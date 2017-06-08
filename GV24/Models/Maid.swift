//
//  Maid.swift
//  GV24
//
//  Created by HuyNguyen on 6/6/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import SwiftyJSON

class Maid: AppModel {
    var id:String?
    var info:Info?
    var time:String?
    override init() {
        super.init()
    }
    override init(json: JSON) {
        super.init(json: json)
        self.id = json["_id"].string
        self.info = Info(json: json["info"])
        self.time = json["time"].string
    }
}
