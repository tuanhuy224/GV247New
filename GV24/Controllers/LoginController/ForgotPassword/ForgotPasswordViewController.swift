//
//  ForgotPasswordViewController.swift
//  GV24
//
//  Created by HuyNguyen on 5/31/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var btRequest: UIButton!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var imageEmail: UIImageView!
    @IBOutlet weak var imgaAvatar: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tfEmail.delegate = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func btRequestAction(_ sender: Any) {
        guard let username = UserDefaultHelper.currentUser?.username else {return}
        guard let email = UserDefaultHelper.currentUser?.email else {return}
        guard let token = UserDefaultHelper.getToken() else {return}
        let header = ["Content-Type":"application/x-www-form-urlencoded","hbbgvauth":token]
        let param = ["username":username,"email":email]
        APIService.shared.post(url: APIPaths().urlMoreMaidForgotPassword(), parameters: param, header: header) { (json, error) in
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Quên mật khẩu"
    }
}
extension ForgotPasswordViewController:KeyboardNotificationsDelegate{
    func keyboardDidShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.frame.origin.y -= keyboardSize.height
                })
            }
        }
    }
    func keyboardDidHide(notification: NSNotification) {
        print("bbb")
    }
}
extension ForgotPasswordViewController:UITextFieldDelegate{
}
