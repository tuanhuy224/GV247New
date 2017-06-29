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
    weak var delegate:customButtonLoginDelegate?
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
        self.title = "login".localize
        btnLogin.setTitle("login".localize, for: .normal)
        forgotPassword.setTitle("forgotPassword".localize, for: .normal)
        userLogin.placeholder = "Username".localize
        passwordLogin.placeholder = "Password".localize
    }
    func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.keyboardHeightLayoutConstraint?.constant = 0.0
            } else {
                self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    func token() -> String {
        return UserDefaultHelper.getString()! + "@//@ios"
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unRegisterAutoKeyboard()
        NotificationCenter.default.removeObserver(self)
    }
    @IBAction func loginButtonAction(_ sender: Any) {
        btnLogin.setBackgroundImage(nil, for: .normal)
        btnLogin.setBackgroundImage(nil, for: .highlighted)
        let apiClient = UserService.sharedInstance
        apiClient.logIn(userName: userLogin.text!, password: passwordLogin.text!, device_token: token(), completion: { (user, string, error) in
            if let user = user{
                print(self.token())
                UserDefaultHelper.setUserDefault(token: string!, user: user)
                guard let window = UIApplication.shared.keyWindow else{return}
                let navi = UINavigationController(rootViewController: HomeViewDisplayController())
                window.rootViewController = navi
            }else{
                AlertStandard.sharedInstance.showAlert(controller: self, title: "", message: "Invalid".localize)
            }
        })
    }
    @IBAction func btAround(_ sender: Any) {
        let navi = WorkAroundController(nibName: NibWorkAroundController, bundle: nil)
        navi.arrays = arrays
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
        btAround.setTitle("Around".localize, for: .normal)
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

