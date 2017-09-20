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
    showBackButton = true
  }

    override func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
  override func setupViewBase() {
    super.setupViewBase()
    tfUsername.placeholder = "Username".localize
    tfEmail.placeholder = "Emailaddress".localize
  }
  @IBAction func btRequestAction(_ sender: Any) {
    guard let username = tfUsername.text,let email = tfEmail.text else{return}
    let param = ["username":username,"email":email]
    if username == ""{
      AlertStandard.sharedInstance.showAlert(controller: self, title: "", message: "Pleaseenteryourname".localize)
      
    }else if email == "" {
      AlertStandard.sharedInstance.showAlert(controller: self, title: "", message: "Pleaseenteryouremailaddress".localize)
    }else if email.isEmail == false {
      AlertStandard.sharedInstance.showAlert(controller: self, title: "", message: "Emailformatisincorrect".localize)
    }else{
      self.alert(param)
    }
    
  }
  fileprivate func alert(_ param:[String:String]){
    AlertStandard.sharedInstance.showAlertCt(controller: self, pushVC: LoginView(), title: "", message: "Apasswordresetlinkissenttoyouremail".localize, buttonTitle: "", completion: {
      self.loadingView.show()
      APIService.shared.postFotGotPassword(url: APIPaths().urlMoreMaidForgotPassword(), method: .post, parameters: param) { (json, error) in
        self.loadingView.close()
        if error == "SUCCESS"{
          let login = LoginView(nibName:"LoginView", bundle: nil)
          guard let window = UIApplication.shared.keyWindow else{return}
          let navi = UINavigationController(rootViewController: login)
          window.rootViewController = navi
        }else{
          
        }
      }
    })
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
    btRequest.backgroundColor = AppColor.backButton
    UIButton.cornerButton(bt: btRequest, radius: 8)
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginView.dismissKeyboard))
    view.addGestureRecognizer(tap)
    
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.title = "Forgotpassword".localize
  }
}
extension ForgotPasswordViewController:UITextFieldDelegate{
  func textFieldDidEndEditing(_ textField: UITextField) {
    
  }
}
