//
//  Dist.swift
//  GV24
//
//  Created by HuyNguyen on 6/8/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import SwiftyJSON

class Dist: AppModel {
    var calculated: Double?
    override init() {
        super.init()
    }
    override init(json: JSON) {
        super.init(json: json)
        self.calculated = json["calculated"].double
    }
}
