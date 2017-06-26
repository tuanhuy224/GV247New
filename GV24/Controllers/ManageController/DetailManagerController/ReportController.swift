//
//  ReportController.swift
//  GV24
//
//  Created by HuyNguyen on 6/26/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Kingfisher
import IoniconsSwift

class ReportController: BaseViewController {
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var nameProfile: UILabel!
    @IBOutlet weak var addressProfile: UILabel!
    @IBOutlet weak var tfReport: UITextView!
    var work = Work()

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.setupView()
        }
        // Do any additional setup after loading the view.
    }
    override func setupViewBase() {
        super.setupViewBase()
        self.navigationItem.title = "Feedback".localize
    }
    func setupView()  {
        nameProfile.font = UIFont(descriptor: UIFontDescriptor.MediumDescriptor(textStyle: UIFontTextStyle.body.rawValue), size: sizeSeven)
        addressProfile.font = UIFont(descriptor: UIFontDescriptor.preferredDescriptor(textStyle: UIFontTextStyle.footnote.rawValue), size: sizeFour)
        imageProfile.layer.cornerRadius = imageProfile.frame.size.width/2
        imageProfile.clipsToBounds = true
        nameProfile.text = work.stakeholders?.owner?.username
        addressProfile.text = work.stakeholders?.owner?.address?.name
        let imag = URL(string: (work.stakeholders?.owner?.image)!)
        imageProfile.kf.setImage(with: imag)
        let button = UIButton(type: .custom)
        button.setTitle("send".localize, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.addTarget(self, action: #selector(ReportController.addTapped), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    func addTapped() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
