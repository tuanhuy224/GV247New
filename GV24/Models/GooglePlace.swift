//
//  GooglePlace.swift
//  Feed Me
//
/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

//let results = dic["results"] as! NSArray
//for result in results {
//    let strObj = result as! NSDictionary
//    let geometry = strObj["geometry"] as! NSDictionary
//    let location = geometry["location"] as! NSDictionary
//    let lat = location["lat"] as! NSNumber
//    let lon = location["lng"] as! NSNumber
//}

import UIKit
import Foundation
import CoreLocation
import SwiftyJSON

class GooglePlace:AppModel {
    var address: String?
    var lat:Double?
    var long:Double?
    var coordinate: CLLocationCoordinate2D?
    var placeType: String?
    var photoReference: String?
    var photo: UIImage?
    override init() {
        super.init()
    }
  override init(json: JSON?){
    super.init(json: json!)

    self.lat = json?["geometry"]["location"]["lat"].double
    self.long = json?["geometry"]["location"]["lng"].double
  }
}
