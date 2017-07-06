//
//  ForgotPasswordViewController.swift
//  GV24
//
//  Created by HuyNguyen on 5/31/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import IoniconsSwift

class ForgotPasswordViewController: BaseViewController {
    
    @IBOutlet weak var btRequest: UIButton!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfUsername: UITextField!
    @IBOutlet weak var imageEmail: UIImageView!
    @IBOutlet weak var imgaAvatar: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tfEmail.delegate = self
        tfUsername.delegate = self
        setup()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func btRequestAction(_ sender: Any) {
        if tfEmail.text == "" || tfUsername.text == ""{
            AlertStandard.sharedInstance.showAlert(controller: self, title: "", message: "Invalid".localize)
        }
        loadingView.show()
        guard let username = tfUsername.text else{return}
        guard let email = tfEmail.text else{return}
        let param = ["username":username,"email":email]
        
        APIService.shared.postFotGotPassword(url: APIPaths().urlMoreMaidForgotPassword(), method: .post, parameters: param) { (json, error) in
            self.loadingView.close()
            if error == "DATA_NOT_EXIST"{
                let login = LoginView(nibName:"LoginView", bundle: nil)
                guard let window = UIApplication.shared.keyWindow else{return}
                let navi = UINavigationController(rootViewController: login)
                window.rootViewController = navi
            }
        }
    }
    func dismissKeyboard() {
        tfUsername.resignFirstResponder()
        tfEmail.resignFirstResponder()
    }
    func setup() {
        let imageprofile = Ionicons.iosPerson.image(32).imageWithColor(color: UIColor.colorWithRedValue(redValue: 162, greenValue: 162, blueValue: 162, alpha: 1))
        imgaAvatar.image = imageprofile
        let imageEmailProfile = Ionicons.iosEmail.image(32).imageWithColor(color: UIColor.colorWithRedValue(redValue: 162, greenValue: 162, blueValue: 162, alpha: 1))
        imageEmail.image = imageEmailProfile
        btRequest.setTitle("Sendrequest".localize, for: .normal)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginView.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Forgotpassword".localize
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
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}
