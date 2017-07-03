//
//  AboutViewController.swift
//  GV24
//
//  Created by HuyNguyen on 5/31/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit


class AboutViewController: UIViewController {

    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var lbAbout: UILabel!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var tfTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tfTextField.text = "Aboutus".localize
        scroll.isScrollEnabled = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "AboutUsTitle".localize
        
    }
    

}
