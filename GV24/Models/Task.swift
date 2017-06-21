//
//  Task.swift
//  GV24
//
//  Created by Macbook Solution on 6/20/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import SwiftyJSON

class Task: AppModel {
    
    var _id: String?
    var address: Address?
    var workTime: WorkTime?
    var price: Double?
    var title: String?
    var taskDescription: String?
    
    override init(json: JSON) {
        super.init()
        self._id = json["_id"].string
        self.address = Address(json: json["info"]["address"])
        self.workTime = WorkTime(json: json["info"]["time"])
        self.price = json["info"]["price"].double
        self.title = json["info"]["title"].string
        self.taskDescription = json["info"]["description"].string
    }
}
