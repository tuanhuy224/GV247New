//
//  AlertManager.swift
//  GV24
//
//  Created by HuyNguyen on 6/2/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import UIKit

class AlertStandard {
   static var sharedInstance = AlertStandard()
    func showAlert(controller: UIViewController, title: String, message: String, buttonTitle:String = "OK") {
        if #available(iOS 8.0, *) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK",
                                              style: .default, handler: nil)
            alertController.addAction(defaultAction)
            DispatchQueue.main.async(execute: { () -> Void in
                controller.present(alertController, animated: true, completion: nil)
            })
        } else {
            // Fallback on earlier versions
            let alert = UIAlertView()
            alert.title = "No"
            alert.message = "Yes"
            alert.addButton(withTitle: "123")
            alert.show()
        }
    }
    func showAlertCt(controller: UIViewController,pushVC:UIViewController, title: String, message: String, buttonTitle:String = "OK") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) -> Void in
            UIView.animate(withDuration: 1, animations: { 
                controller.navigationController?.pushViewController(pushVC, animated: true)
            })
        }
        let noAction = UIAlertAction(title: "No", style: .default) { (action) -> Void in
        }
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        controller.present(alertController, animated: true, completion: nil)
    }

//    func showAlertWithIcon(controller: UIViewController, title: String, message: String, buttonTitle:String) {
//        
//        if #available(iOS 8.0, *) {
//            let lb:UILabel = UILabel(frame: CGRectMake(130, -10, 80, 80))
//            lb.font = UIFont(name: "FontAwesome", size: 18)
//            lb.text = "\u{f00c}"
//            lb.textColor = UIColor(red: 0/255, green: 118/255, blue: 255/255, alpha: 1)
//            
//            let alertController = UIAlertController(title: title, message: helper.getLocalizedStringForKey(message), preferredStyle: .Alert)
//            alertController.view.addSubview(lb)
//            
//            controller.presentViewController(alertController, animated: true, completion: nil)
//            let delay = 2.0 * Double(NSEC_PER_SEC)
//            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
//            dispatch_after(time, dispatch_get_main_queue(), {
//                controller.dismissViewControllerAnimated(true, completion: { () -> Void in
//                    
//                })
//            })
//        }else{
//            let lb:UILabel = UILabel(frame: CGRectMake(170, -100, 20, 20))
//            lb.font = UIFont(name: "FontAwesome", size: 18)
//            lb.text = "\u{f00c}"
//            lb.textColor = UIColor(red: 0/255, green: 118/255, blue: 255/255, alpha: 1)
//            
//            let alert = UIAlertView()
//            alert.frame.size.width = 150
//            alert.frame.size.height = 50
//            alert.title = ""
//            alert.message = helper.getLocalizedStringForKey(message)
//            
//            //            var imageView = UIImageView(frame: CGRectMake(0, 0, 80, 80))
//            //            imageView.image = UIImage(named: image)
//            alert.setValue(lb, forKey: "accessoryView")
//            
//            alert.show()
//            
//            let delay = 2.0 * Double(NSEC_PER_SEC)
//            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
//            dispatch_after(time, dispatch_get_main_queue(), {
//                alert.dismissWithClickedButtonIndex(-1, animated: true)
//            })
//        }
}

