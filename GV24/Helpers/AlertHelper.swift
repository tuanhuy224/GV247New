//
//  AlertHelper.swift
//  GV24
//
//  Created by admin on 6/13/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class AlertHelper: NSObject {
    static let sharedInstance = AlertHelper()
    
    func showAlertError(title: String, message: String) -> UIAlertController{
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(okAction)
        return alertController
    }
}
