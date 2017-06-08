//
//  Around.swift
//  GV24
//
//  Created by HuyNguyen on 6/8/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import Foundation
import SwiftyJSON


class Around: AppModel {
    var id:WorkName?
    var count:Int?
    override init() {
        super.init()
    }
    override init(json: JSON) {
        super.init(json: json)
        self.count = json["count"].int
        self.id = WorkName(json: json["_id"])
    }
}
