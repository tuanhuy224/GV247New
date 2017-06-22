//
//  Statistic.swift
//  GV24
//
//  Created by HuyNguyen on 6/22/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import SwiftyJSON

class Statistic: AppModel {
    var totalPrice:Int?
    var task:TaskStatistic?
    override init() {
        super.init()
    }
    override init(json: JSON) {
        super.init(json: json)
        self.totalPrice = json["totalPrice"].int ?? 0
        self.task = TaskStatistic(json: json["task"])
    }
}
class TaskStatistic: AppModel {
    var id:String?
    var count:Int?
    override init() {
        super.init()
    }
    override init(json: JSON) {
        super.init(json: json)
        self.id = json["_id"].string ?? ""
        self.count = json["count"].int ?? 0
    }
}
