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
    func buttonLogin()
   @objc optional func buttonForgot()
}

class LoginView: CustomView {

    @IBOutlet weak var imagePassword: UIImageView!
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var forgotPassword: UIButton!
    @IBOutlet weak var imgeLogo: UIImageView!
    @IBOutlet weak var userLogin: UITextField!
    @IBOutlet weak var passwordLogin: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    weak var delegate:customButtonLoginDelegate?
    @IBAction func loginButtonAction(_ sender: Any) {
        if (delegate != nil) {
            delegate?.buttonLogin()
        }
    }

    @IBAction func forgotPasswordAction(_ sender: Any) {
        if (delegate != nil) {
            delegate?.buttonForgot!()
        }
    }

    override func setupView()  {
        let imageprofile = Ionicons.iosPerson.image(18)
        imageProfile.image = imageprofile
        let imagepassword = Ionicons.iosLocked.image(12)
        imagePassword.image = imagepassword
    }

}
