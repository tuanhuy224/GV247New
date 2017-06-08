//
//  Work.swift
//  GV24
//
//  Created by HuyNguyen on 5/27/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import SwiftyJSON

class Work: AppModel {
    var id:String?
    var stakeholders:Stakeholders?
    var info:Info?
    var history:History?
    var process: Process?
    var workTime: WorkTime?
    var dist:Dist?

    override init(json:JSON) {
        super.init()
        self.id = json["_id"].string
        self.stakeholders = Stakeholders(json: json["stakeholders"])
        self.info = Info(json: json["info"])
        self.process = Process(json: json["process"])
        self.workTime = WorkTime(json: json["info"]["time"])
        self.dist = Dist(json: json["dist"])
        self.history = History(json: json["history"])
    }
}

class WorkTime: AppModel {
    var startAt: String?
    var endAt: String?
    var hour: Int?
    
    override init(json: JSON) {
        super.init()
        
        self.startAt = json["startAt"].string
        self.endAt = json["endAt"].string
        self.hour = json["hour"].int
    }
    
}
