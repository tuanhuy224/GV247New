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
        self.id = json?["_id"].stringValue
        self.username = json?["info"]["username"].stringValue
        self.phone = json?["info"]["phone"].stringValue
        self.image = json?["info"]["image"].stringValue
        self.gender = json?["info"]["gender"].intValue
        self.email = json?["info"]["email"].stringValue
        self.info = Info(json: (json?["info"])!)
        self.address = Address(json:(json?["info"]["address"])!)
        self.name = json?["info"]["name"].stringValue
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
    func convertToWork(owner: Owner) -> Work?{
        let work = Work()
        work.id = "teste"
        let newOwner = Owner()
        newOwner.id = (owner.id)!
        newOwner.gender = (owner.gender)!
        let newAddress = Address()
        newAddress.name = (owner.address?.name)!
        newOwner.address = newAddress
        newOwner.phone = (owner.phone)!
        newOwner.image = (owner.image)!
        newOwner.name = (owner.name)!
        newOwner.username = (owner.username)!
        let newStakeholder = Stakeholders()
        work.stakeholders = newStakeholder
        newStakeholder.owner = newOwner
        return work
    }
}
