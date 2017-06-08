//
//  ConstactViewController.swift
//  GV24
//
//  Created by HuyNguyen on 5/31/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class ConstactViewController: BaseViewController {
    @IBOutlet weak var callPhone: UIButton!
    @IBOutlet weak var emailButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Liên hệ"
    }
    @IBAction func callPhoneAction(_ sender: Any) {
    }

    @IBAction func emailAction(_ sender: Any) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
