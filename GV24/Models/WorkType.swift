//
//  WorkType.swift
//  GV24
//
//  Created by Macbook Solution on 6/28/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import SwiftyJSON

class WorkType: AppModel {
    var id: String?
    var image: String?
    var name: String?
    var workDescription : String?
    var title : String?
    var weight : Int?
    var price : NSNumber?
    var tools : Bool? = false
    var suggests : [Suggest] = [Suggest]()
    
    override init() {
        super.init()
    }
    
    override init(json: JSON) {
        super.init(json: json)
        self.id = json["_id"].string
        self.image = json["image"].string
        self.name = json["name"].string
        self.workDescription = json["description"].string
        self.title = json["title"].string
        self.price = json["price"].number
        self.weight = json["weight"].int
        self.tools = json["tools"].bool
        
        let suggetsJson = json["suggest"].arrayValue
        for suggestData in (suggetsJson as [JSON]) {
            self.suggests.append(Suggest(json: suggestData))
        }

    }
}

class Suggest : AppModel{
    var id : String?
    var name : String?
    
    override init() {
        super.init()
    }
    
    override init(json: JSON) {
        super.init(json: json)
        self.id = json["_id"].string
        self.name = json["name"].string
    }
}
