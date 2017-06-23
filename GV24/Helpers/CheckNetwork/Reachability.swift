//
//  Reachability.swift
//  GV24
//
//  Created by HuyNguyen on 6/23/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import Foundation
import SystemConfiguration
import Alamofire

class NetworkStatus {
    static let sharedInstance = NetworkStatus()
    private init() {}
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.apple.com")
    func startNetworkReachabilityObserver() {
        reachabilityManager?.listener = { status in
            switch status {
            case .notReachable:
                print("The network is not reachable")
            case .unknown :
                print("It is unknown whether the network is reachable")
            case .reachable(.ethernetOrWiFi):
                print("The network is reachable over the WiFi connection")
            case .reachable(.wwan):
                print("The network is reachable over the WWAN connection")
            }
        }
        reachabilityManager?.startListening()
    }
}
