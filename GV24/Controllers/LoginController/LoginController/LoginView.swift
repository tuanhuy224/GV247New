//
//  HomeViewController.swift
//  GV24
//
//  Created by admin on 5/23/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import IoniconsSwift

@objc protocol customButtonLoginDelegate:class {
    func buttonLogin(username:String,password:String)
    @objc optional func sendTextfield(login:UITextField,password:UITextField)
    @objc optional func buttonForgot()
}

class LoginView: BaseViewController {
    
    @IBOutlet weak var scrollLogin: UIScrollView!

    @IBOutlet weak var imagePassword: UIImageView!
    @IBOutlet weak var imageProfile: UIImageView!{
        didSet{
        }
    }
    @IBOutlet weak var forgotPassword: UIButton!
    @IBOutlet weak var imgeLogo: UIImageView!
    @IBOutlet weak var userLogin: UITextField!
    @IBOutlet weak var passwordLogin: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    weak var delegate:customButtonLoginDelegate?
    var user:User?
    override func viewDidLoad() {
        super.viewDidLoad()
        userLogin.delegate = self
        passwordLogin.delegate = self
        self.setupView()
    }

    @IBAction func loginButtonAction(_ sender: Any) {
        btnLogin.setBackgroundImage(nil, for: .normal)
        btnLogin.setBackgroundImage(nil, for: .highlighted)
            let apiClient = UserService.sharedInstance
            apiClient.logIn(userName: userLogin.text!, password: passwordLogin.text!, completion: { (user, string, error) in
                if let user = user{
                    UserDefaultHelper.setUserDefault(token: string!, user: user)
                    
                    guard let window = UIApplication.shared.keyWindow else{return}
                    let navi = UINavigationController(rootViewController: HomeViewDisplayController())
                    window.rootViewController = navi
                }else{
                
                }
            })
    }
    @IBAction func forgotPasswordAction(_ sender: Any) {
        
    }
   func setupView()  {
        let imageprofile = Ionicons.iosPerson.image(18)
        imageProfile.image = imageprofile.maskWithColor(color: UIColor.gray)
        imageProfile.image = imageprofile
    
        let imagepassword = Ionicons.iosLocked.image(18)
        imagePassword.image = imagepassword.maskWithColor(color: UIColor.gray)
        imagePassword.image = imagepassword
    
    NotificationCenter.default.addObserver(self, selector: #selector(LoginView.keyboardWillShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(LoginView.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginView.dismissKeyboard))
    view.addGestureRecognizer(tap)
    }
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        view.endEditing(true)
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        print("delloc")
    }
    
    func keyboardWillShow(notification : Notification){
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.frame.origin.y -= keyboardSize.height
                })
                
            }
        }
    }
    
    func keyboardWillHide(notification : Notification){
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.frame.origin.y += keyboardSize.height
                })
            }
        }
    }


    
}
extension LoginView:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        passwordLogin = textField
    }

}

