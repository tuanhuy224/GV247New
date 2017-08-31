//
//  Info.swift
//  GV24
//
//  Created by HuyNguyen on 5/28/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import SwiftyJSON

class Info: AppModel {
    var title:String?
    var package:Package?
    var workName:WorkName?
    var history:History?
    var content: String?
    var salary: Int?
    var address: Address?
    var time: Time?
    var tools: Bool?
    
    override init() {
        super.init()
    }
    override init(json: JSON) {
        super.init()
        self.title  = json["title"].stringValue
        self.workName = WorkName(json: json["work"])
        self.history = History(json: json["history"])
        self.content = json["description"].string
        self.salary = json["price"].int
        self.address = Address(json: json["address"])
        self.tools = json["tools"].bool
        self.time = Time(json: json["time"])
    }   
}
class Package: Info {
    var id:String?
    var name:String?
}

class WorkName:AppModel {
    var id:String?
    var image:String?
    var name:String?
    override init(json: JSON) {
        super.init(json: json)
        self.id = json["_id"].stringValue
        self.name = json["name"].stringValue
        self.image = json["image"].stringValue
    }
}
class Time: AppModel {
    var hour: Int?
    var endAt: String?
    var startAt: String?
    
    
    override init(json: JSON) {
        super.init(json: json)
        self.hour = json["hour"].intValue
        self.endAt = json["endAt"].stringValue
        self.startAt = json["startAt"].stringValue
    }
}
