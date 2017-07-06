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
    
    var totalPrice:Int = 0
    var tasks = [TaskStatistic]()
    
    override init() {
        super.init()
    }
    
    override init(json: JSON) {
        super.init(json: json)
        self.totalPrice = json["totalPrice"].int ?? 0
        if let task = json["task"].array {
            for info in task {
                self.tasks.append(TaskStatistic(json: info))
            }
        }
    }
}


enum TaskType: String {
    case completed = "000000000000000000000005"
    case inProcess = "000000000000000000000004"
    case awaiting  = "000000000000000000000003"
    case unknown
}

class TaskStatistic: AppModel {
    var id:TaskType = .unknown
    var count:Int = 0
    override init() {
        super.init()
    }
    override init(json: JSON) {
        super.init(json: json)
        
        if let id = json["_id"].string, let type = TaskType(rawValue: id) {
            self.id = type
        }
        self.count = json["count"].int ?? 0
    }
}
