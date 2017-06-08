//
//  Home.swift
//  GV24
//
//  Created by HuyNguyen on 5/25/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import SwiftyJSON

class User: AppModel {
    var id:String?
    var gender:Int?
    var name:String?
    var phone:String?
    var email:String?
    var username:String?
    var image:String?
    var address:Address?
    var owner:Owner?
    var lat:Double?
    var lng:Double?
    
    override init(){
    super.init()
    }
    override init(json:JSON?) {
        super.init()
        self.id = json?["_id"].string
        self.gender = json?["info"]["gender"].int
        self.name = json?["info"]["name"].string
        self.phone = json?["info"]["phone"].string
        self.username = json?["info"]["username"].string
        self.email = json?["info"]["email"].string
        self.image = json?["info"]["image"].string
        self.address = Address(json:(json?["info"]["address"])!)
        self.owner = Owner(json: (json?["stakeholders"]["owner"])!)
        
    }
}

class DataUser: User {
    var data:[User]?
    init?(json data:JSON) {
    super.init(json: data)
        
    }
    
    func parseData(json: JSON) -> [DataUser] {
        var results:[DataUser] = [DataUser]()
        if let dataItems = json.array {
            for item in dataItems {
                results.append(DataUser(json:item)!)
            }
        }
        return results
    }

}

