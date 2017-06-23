//
//  Enum.swift
//  GV24
//
//  Created by HuyNguyen on 6/12/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import UIKit

enum WorkStatus: String {
    case OnCreate = "000000000000000000000001"
    case Pending = "000000000000000000000002"
    case Recieved = "000000000000000000000003"
    case OnDoing = "000000000000000000000004"
    case Done = "000000000000000000000005"
}

enum ResultStatus: String {
    case Success     = "Success"
    case EmptyData   = "NoDataFound"
    case Unauthorize = "ErrorWhileRetrievingInformationFromServer"
}

enum enumGender:String {
    case Boy = "Boy"
    case Girl = "Girl"
}
