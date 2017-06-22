//
//  Contact.swift
//  GV24
//
//  Created by HuyNguyen on 6/22/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import SwiftyJSON

class Contact: AppModel {
    var id:String?
    var name:String?
    var phone:String?
    var email:String?
    var address:String?
    override init(){
        super.init()
    }
    override init(json:JSON?) {
        super.init()
        self.id = json?["_id"].string ?? ""
        self.name = json?["name"].string ?? ""
        self.phone = json?["phone"].string ?? ""
        self.address = json?["address"].string ?? ""
        self.email = json?["email"].string ?? ""
        
    }
}
