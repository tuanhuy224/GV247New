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
import Alamofire

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
        button.setTitleColor(UIColor.colorWithRedValue(redValue: 90, greenValue: 186, blueValue: 189, alpha: 1), for: UIControlState.normal)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        button.addTarget(self, action: #selector(ReportController.addTapped), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    func addTapped() {
        sendReport()
    }
    
    func sendReport(){
        var params:[String:Any] = [:]
        if let content = tfReport.text, !content.isEmpty {
            if let toID = work.stakeholders?.owner?.id {
                params["toId"] = "\(toID)"
                params["content"] = content
                let header: HTTPHeaders = ["hbbgvauth":"\(UserDefaultHelper.getToken()!)", "Content-Type":"application/x-www-form-urlencoded"]
                APIService.shared.postReserve(url: APIPaths().urlSendReport(), method: HTTPMethod.post, parameters: params, header: header, completion: { (data, message) in
                    if message! == "SUCCESS" {
                        self.showAlert(isSuccess: true)
                    }else {
                        self.showAlert(isSuccess: false)
                    }
                })
            }
        }else {
            AlertStandard.sharedInstance.showAlert(controller: self, title: "Announcement".localize, message: "Please enter your feedback", buttonTitle: "OK")
        }
    }

    func showAlert(isSuccess: Bool) {
        let message = (isSuccess == true) ? "SendReportSuccess".localize : "SendReportFailure".localize
        let alertController = UIAlertController(title: "Announcement".localize, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alertAction) in
            if isSuccess == true {self.navigationController?.popViewController(animated: true)}
        })
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

}
