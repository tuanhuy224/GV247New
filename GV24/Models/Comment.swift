//
//  Comment.swift
//  GV24
//
//  Created by admin on 6/9/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import SwiftyJSON

class Comment: AppModel {
    
    var _id: String?
    var createAt: String?
    var content: String?
    var fromId: User?
    var task: Task?
    
    override init(json: JSON) {
        super.init()
        self._id = json["_id"].string
        self.createAt = json["createAt"].string
        self.content = json["content"].string
        self.fromId = User(json: json["fromId"])
        self.task = Task(json: json["task"])
    }
}
