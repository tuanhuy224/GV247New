//
//  RuleViewController.swift
//  GV24
//
//  Created by HuyNguyen on 5/31/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class RuleViewController: UIViewController {

    @IBOutlet weak var tfTextFiled: UITextView!
    @IBOutlet weak var lbRule: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "TermsofuseTitle".localize
        tfTextFiled.text = "Termsofuse".localize
        tfTextFiled.isEditable = false
    }

}
