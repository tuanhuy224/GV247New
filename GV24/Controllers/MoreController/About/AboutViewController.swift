//
//  AboutViewController.swift
//  GV24
//
//  Created by HuyNguyen on 5/31/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit


class AboutViewController: BaseViewController {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var imageLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadHTMLString("Aboutus".localize, baseURL: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "AboutUsTitle".localize

    }
}
