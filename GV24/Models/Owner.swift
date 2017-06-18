//
//  Owner.swift
//  GV24
//
//  Created by HuyNguyen on 6/3/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import SwiftyJSON

class Owner: AppModel {
    var id:String?
    var username:String?
    var phone:String?
    var email:String?
    var image:String?
    var gender:Int?
    var name:String?
    var info:Info?
    var address:Address?
    var latOwner:Double?
    var lngOwner:Double?
    var workTime: [String] = []
    
    override init(){
        super.init()
    }
    override init(json:JSON?) {
        super.init()
        self.id = json?["_id"].string
        self.username = json?["info"]["username"].string
        self.phone = json?["info"]["phone"].string
        self.image = json?["info"]["image"].string
        self.gender = json?["info"]["gender"].int
        self.email = json?["info"]["email"].string
        self.info = Info(json: (json?["info"])!)
        self.address = Address(json:(json?["info"]["address"])!)
        self.name = json?["info"]["name"].string
    }
    func convertToUser() -> User? {
        let user: User = User()
        user.id = self.id
        user.gender = self.gender
        user.name = self.name
        user.phone = self.phone
        user.email = self.email
        user.username = self.username
        user.image = self.image
        user.address = self.address
        user.lat = self.latOwner
        user.lng = self.lngOwner
        return user
    }
}
