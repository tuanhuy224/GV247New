//
//  HomeViewController.swift
//  GV24
//
//  Created by admin on 5/23/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import IoniconsSwift
import Alamofire
import FirebaseMessaging
import Firebase
import FirebaseInstanceID

@objc protocol customButtonLoginDelegate:class {
    func buttonLogin(username:String,password:String)
    @objc optional func sendTextfield(login:UITextField,password:UITextField)
    @objc optional func buttonForgot()
}
class LoginView: BaseViewController {
    @IBOutlet weak var blurImage: UIVisualEffectView!
    @IBOutlet weak var Sview: UIView!
    @IBOutlet weak var scrollLogin: UIScrollView!
    @IBOutlet weak var imagePassword: UIImageView!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var forgotPassword: UIButton!
    @IBOutlet weak var imgeLogo: UIImageView!
    @IBOutlet weak var userLogin: UITextField!
    @IBOutlet weak var passwordLogin: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var scrollBt: NSLayoutConstraint!
    @IBOutlet weak var btAround: UIButton!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var btRegister: UIButton!
    weak var delegate:customButtonLoginDelegate?
    let loading = LoadingView()
    var user:User?
    var arrays = [Around]()
    override func viewDidLoad() {
        super.viewDidLoad()
        userLogin.delegate = self
        passwordLogin.delegate = self
        scrollLogin.isScrollEnabled = true
        scrollLogin.delegate = self
        self.setupView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerAutoKeyboard()
        self.title = "SignIn".localize
        btnLogin.setTitle("SignIn".localize.uppercased(), for: .normal)
        forgotPassword.setTitle("Forgotpassword".localize, for: .normal)
        userLogin.placeholder = "Username".localize
        passwordLogin.placeholder = "Password".localize
        btRegister.setTitle("SignUpNow".localize, for: .normal)
    }
    func token() -> String {
        guard let firebaseToken = InstanceID.instanceID().token() else {return ""}
        return firebaseToken + "@//@ios"
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unRegisterAutoKeyboard()
        NotificationCenter.default.removeObserver(self)
    }
    @IBAction func loginButtonAction(_ sender: Any) {
        loading.show()
        let apiClient = UserService.sharedInstance
        guard let username = userLogin.text, let password = passwordLogin.text else {return}
        if username == "" || password == "" {
            AlertStandard.sharedInstance.showAlert(controller: self, title: "", message: "Pleasecompleteallinformation".localize)
        }
        apiClient.logIn(userName: username, password: password, device_token: token(), completion: { (user, string, error) in
            self.loading.close()
            if self.isLoginWhenChangeToken == true{
                self.isLoginWhenChangeToken = false
                UserDefaultHelper.setUserDefault(token: string!, user: user)
                
                // pop to previous controller if can. Otherwise, pop to root controller
                if let navigation = self.navigationController{
                    if navigation.viewControllers.contains(self.viewControllerLogin) {
                        navigation.popToViewController(self.viewControllerLogin, animated: true)
                    } else {
                        guard let window = UIApplication.shared.keyWindow else{return}
                        let navi = UINavigationController(rootViewController: HomeViewDisplayController())
                        window.rootViewController = navi
                    }
                }
            }else{
                if let user = user{
                    UserDefaultHelper.setUserDefault(token: string!, user: user)
                    guard let window = UIApplication.shared.keyWindow else{return}
                    let navi = UINavigationController(rootViewController: HomeViewDisplayController())
                    window.rootViewController = navi
                    }else{
                    AlertStandard.sharedInstance.showAlert(controller: self, title: "", message: "Invalid".localize)
                }
            }
        })
        self.dismissKeyboard()
    }
  
  @IBAction func btRegisterAction(_ sender: Any) {
    let navi = RegisterViewController(nibName: "RegisterViewController", bundle: nil)
    navigationController?.pushViewController(navi, animated: true)
  }
  
    
    @IBAction func btAround(_ sender: Any) {
        let navi = MapViewController(nibName: "MapViewController", bundle: nil)
        navigationController?.pushViewController(navi, animated: true)
    }
    @IBAction func forgotPasswordAction(_ sender: Any) {
        self.navigationController?.pushViewController(ForgotPasswordViewController(), animated: true)
        
    }
    func setupView()  {
        let imageprofile = Ionicons.iosPerson.image(32).imageWithColor(color: UIColor.colorWithRedValue(redValue: 162, greenValue: 162, blueValue: 162, alpha: 1))
        imageProfile.image = imageprofile
        let imagepassword = Ionicons.locked.image(32).imageWithColor(color: UIColor.colorWithRedValue(redValue: 162, greenValue: 162, blueValue: 162, alpha: 1))
        imagePassword.image = imagepassword
        btAround.setTitle("Nearby".localize, for: .normal)
        btAround.backgroundColor = UIColor.colorWithRedValue(redValue: 253, greenValue: 190, blueValue: 78, alpha: 1)
        logoImage.backgroundColor = UIColor.clear
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginView.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        userLogin.resignFirstResponder()
        passwordLogin.resignFirstResponder()
    }
}
extension LoginView:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
}
extension LoginView:UIScrollViewDelegate{
}

