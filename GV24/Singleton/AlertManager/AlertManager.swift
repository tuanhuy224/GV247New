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
    // MARK: - show login view when logout button touch
    func showAlertSetRoot(controller: UIViewController,pushVC:UIViewController, title: String, message: String, buttonTitle:String = "OK") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) -> Void in
            UIView.animate(withDuration: 1, animations: {
                guard let window = UIApplication.shared.keyWindow else{return}
                let navi = UINavigationController(rootViewController: pushVC)
                window.rootViewController = navi
            })
        }
        let noAction = UIAlertAction(title: "No", style: .default) { (action) -> Void in
        }
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        controller.present(alertController, animated: true, completion: nil)
    }
    

}

