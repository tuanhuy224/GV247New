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
class LoginView: BaseViewController,CLLocationManagerDelegate {

    @IBOutlet weak var linePassword: UIView!
    @IBOutlet weak var lineUsername: UIView!
    @IBOutlet weak var vLogin: UIView!
    @IBOutlet weak var blurImage: UIVisualEffectView!
    @IBOutlet weak var Sview: UIView!
    @IBOutlet weak var scrollLogin: UIScrollView!

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
    let locationManager = CLLocationManager()
    let loading = LoadingView()
    var user:User?
    var arrays = [Around]()
    override func viewDidLoad() {
        super.viewDidLoad()
        userLogin.delegate = self
        passwordLogin.delegate = self
        scrollLogin.delegate = self
        self.setupView()
        navigationController?.isNavigationBarHidden = true

    }
    
    func location() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        NotificationCenter.default.removeObserver(self)
    }
    @IBAction func loginButtonAction(_ sender: Any) {
        loading.show()
        let apiClient = UserService.sharedInstance
        guard let username = userLogin.text, let password = passwordLogin.text else {return}
        if username == "" || password == "" {
            AlertStandard.sharedInstance.showAlert(controller: self, title: "", message: "Pleasecompleteallinformation".localize)
        }
        let network = NetworkStatus.sharedInstance.reachabilityManager?.isReachableOnEthernetOrWiFi
        if network == false {
            loading.close()
            AlertStandard.sharedInstance.showAlert(controller: self, title: "", message: "Nointernetconnection".localize)
        }else{
            apiClient.logIn(userName: username, password: password, device_token: token(), completion: { (user, string, error) in
                self.loading.close()
                let home = HomeViewDisplayController()
                if self.isLoginWhenChangeToken == true{
                    self.isLoginWhenChangeToken = false
                    guard let string = string else {return}
                    UserDefaultHelper.setUserDefault(token: string, user: user)
                    
                    // pop to previous controller if can. Otherwise, pop to root controller
                    if let navigation = self.navigationController{
                        if navigation.viewControllers.contains(self.viewControllerLogin) {
                            navigation.popToViewController(self.viewControllerLogin, animated: true)
                        } else {
                            guard let window = UIApplication.shared.keyWindow else{return}
                            
                            //let navi = UINavigationController(rootViewController: HomeViewDisplayController())
                            window.rootViewController = home
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
        }
        self.dismissKeyboard()
    }
  
  @IBAction func btRegisterAction(_ sender: Any) {
    let navi = UINavigationController(rootViewController: RegisterViewController())
    self.present(navi, animated: true, completion: nil)
  
    }
  
    
    @IBAction func btAround(_ sender: Any) {
        let navi = UINavigationController(rootViewController: WorksAroundViewController())
        self.present(navi, animated: true, completion: nil)
//        self.navigationController?.pushViewController(WorksAroundViewController(), animated: true)
    }
    
    @IBAction func forgotPasswordAction(_ sender: Any) {
        let navi = UINavigationController(rootViewController: ForgotPasswordViewController())
        self.present(navi, animated: true, completion: nil)
    }
    
    func cornerButton(_ button: UIButton, _ radius: CGFloat) {
        button.layer.cornerRadius = radius
        button.clipsToBounds = true
    }
    
    func setupView()  {
        vLogin.layer.cornerRadius = 8
        vLogin.clipsToBounds = true
        lineUsername.backgroundColor = UIColor.colorWithRedValue(redValue: 19, greenValue: 111, blueValue: 167, alpha: 1)
        linePassword.backgroundColor = UIColor.colorWithRedValue(redValue: 19, greenValue: 111, blueValue: 167, alpha: 1)
        btAround.setTitle("Nearby".localize, for: .normal)
        btAround.backgroundColor = UIColor.colorWithRedValue(redValue: 253, greenValue: 191, blueValue: 78, alpha: 1)
        btnLogin.backgroundColor = UIColor.colorWithRedValue(redValue: 19, greenValue: 111, blueValue: 167, alpha: 1)
        cornerButton(btnLogin, 8)
        cornerButton(btAround, 8)

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

