//
//  RegisterViewController.swift
//  GV24
//
//  Created by HuyNguyen on 7/20/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController {
  @IBOutlet weak var comment: KMPlaceholderTextView!
  @IBOutlet weak var tfName: UITextField!
  @IBOutlet weak var tfEmail: UITextField!
  @IBOutlet weak var tfPhone: UITextField!
  @IBOutlet weak var btRegister: UIButton!
  @IBOutlet weak var vComment: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
  override func setupViewBase() {
    super.setupViewBase()
    self.title = "RegisterNow".localize
    vComment.layer.borderWidth = 0.5
    vComment.layer.borderColor = UIColor.lightGray.cgColor
    vComment.layer.cornerRadius = 5
    vComment.clipsToBounds = true
    btRegister.setTitle("RegisterNow".localize, for: .normal)
    tfName.placeholder = "Fullname".localize
    tfEmail.placeholder = "Emailaddress".localize
    tfPhone.placeholder = "Phonenumber".localize
    comment.placeholder = "Pleaseleaveusabriefdescriptionofyourself".localize
  }
  
  @IBAction func btRegisterAction(_ sender: Any) {
    //let apiClient = UserService.sharedInstance
    guard let email = tfEmail.text, let name = tfName.text,let phone = tfPhone.text else {return}
    if email == "" || name == "" || phone == "" {
      AlertStandard.sharedInstance.showAlert(controller: self, title: "", message: "Invalid".localize)
    }
  }
}
