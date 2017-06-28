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
    
    override init() {
        super.init()
    }
    
    override init(json: JSON) {
        super.init(json: json)
        self.id = json["_id"].string
        self.image = json["image"].string
        self.name = json["name"].string
    }
}
