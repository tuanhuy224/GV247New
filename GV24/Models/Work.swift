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

    override init() {
        super.init()
    }
    override init(json:JSON) {
        super.init()
        self.id = json["_id"].stringValue
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
        
        self.startAt = json["startAt"].stringValue
        self.endAt = json["endAt"].stringValue
        self.hour = json["hour"].intValue
    }
}

class NearbyWork: AppModel {
    var total: Int?
    var limit: Int?
    var page: Int?
    var pages: Int?
    var works: [Work]?
    
    override init(json: JSON) {
        super.init(json: json)
        self.total = json["total"].intValue
        self.limit = json["limit"].intValue
        self.page = json["page"].intValue
        self.pages = json["pages"].intValue
        self.works = json["docs"].array?.map { return Work(json: $0) }
    }
    
}
