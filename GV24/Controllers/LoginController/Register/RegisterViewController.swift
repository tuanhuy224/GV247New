//
//  RegisterViewController.swift
//  GV24
//
//  Created by HuyNguyen on 7/20/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Alamofire

class RegisterViewController: BaseViewController {
  @IBOutlet weak var comment: KMPlaceholderTextView!
  @IBOutlet weak var tfName: UITextField!
  @IBOutlet weak var tfEmail: UITextField!
  @IBOutlet weak var tfPhone: UITextField!
  @IBOutlet weak var btRegister: UIButton!
  @IBOutlet weak var vComment: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        showBackButton = true

    }
  override func setupViewBase() {
    super.setupViewBase()
    self.title = "SignUp".localize
    vComment.layer.borderWidth = 0.5
    vComment.layer.borderColor = UIColor.lightGray.cgColor
    vComment.layer.cornerRadius = 5
    vComment.clipsToBounds = true
    btRegister.setTitle("SignUp".localize, for: .normal)
    tfName.placeholder = "Fullname".localize
    tfEmail.placeholder = "Emailaddress".localize
    tfPhone.placeholder = "Phonenumber".localize
    comment.placeholder = "Pleaseleaveusabriefdescriptionofyourself".localize
    comment.font = fontSize.fontName(name: .regular, size: 15)
    tfPhone.font = fontSize.fontName(name: .regular, size: 15)
    tfName.font = fontSize.fontName(name: .regular, size: 15)
    tfEmail.font = fontSize.fontName(name: .regular, size: 15)
    btRegister.setTitleColor(AppColor.white, for: .normal)
    btRegister.backgroundColor = AppColor.backButton
    UIButton.cornerButton(bt: btRegister, radius: 8)
    
  }
    override func goBack() {
        super.goBack()
        self.navigationController?.popViewController(animated: true)
    }
  
  @IBAction func btRegisterAction(_ sender: Any) {
    let apiClient = APIService.shared
    guard let email = tfEmail.text, let name = tfName.text,let phone = tfPhone.text,let note = comment.text else {return}

    if name == ""{
      AlertStandard.sharedInstance.showAlert(controller: self, title: "", message: "Pleaseenteryourfullname".localize)
      
    }else if email == "" {
      AlertStandard.sharedInstance.showAlert(controller: self, title: "", message: "Pleaseenteryouremailaddress".localize)

    }else if phone == "" {
      AlertStandard.sharedInstance.showAlert(controller: self, title: "", message: "Pleaseenteryourphonenumber".localize)
    }
    if phone.isPhoneNumber == false {
        AlertStandard.sharedInstance.showAlert(controller: self, title: "", message: "Pleaseenteryourphonenumber".localize)
    }
    if email.isEmail == false {
      AlertStandard.sharedInstance.showAlert(controller: self, title: "", message: "Emailformatisincorrect".localize)
    }
    let headers = ["Content-Type":"application/x-www-form-urlencoded"]
    let parameters:Parameters = ["name":name,"address":email,"phone":phone, "note":note]
    loadingView.show()
    apiClient.postReserve(url: APIPaths().register(), method: .post, parameters: parameters, header: headers) { (json, error) in
        self.loadingView.close()
      if error == "SUCCESS"{
        AlertStandard.sharedInstance.showAlertCt(controller: self, title: "", message: "Requestsentsuccessfully".localize, completion: { 
          self.navigationController?.popViewController(animated: true)
        })
      }
    }
  }
}
