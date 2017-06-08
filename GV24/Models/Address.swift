//
//  Address.swift
//  GV24
//
//  Created by HuyNguyen on 5/30/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation
class Address: AppModel {
    var name : String?
    var location : CLLocationCoordinate2D?
    override init() {
        super.init()
    }
    init(name : String, location : CLLocationCoordinate2D){
        super.init()
        self.name = name
        self.location = location
    }
    override init(json : JSON){
        super.init(json: json)
        self.name = json["name"].string
        self.location = CLLocationCoordinate2D()
        guard let addressLocation = json["coordinates"].dictionary  else {return}
        self.location?.latitude = (addressLocation["lat"]?.double)!
        self.location?.longitude = (addressLocation["lng"]?.double)!
    }
}
