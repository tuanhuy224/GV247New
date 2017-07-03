//
//  ConstactViewController.swift
//  GV24
//
//  Created by HuyNguyen on 5/31/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Alamofire
import MessageUI

class ConstactViewController: BaseViewController {
    @IBOutlet weak var callPhone: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    var contact:Contact?
    let mailComposerVC = MFMailComposeViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        getContactForMore()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Contact".localize
        self.callPhone.setTitle("Call".localize, for: .normal)
        //self.emailButton.setTitle("".localize, for: .normal)
    }
    @IBAction func callPhoneAction(_ sender: Any) {
        if let url = NSURL(string: "tel://\(contact!.phone!)"){
        UIApplication.shared.openURL(url as URL)
        }
    }

    @IBAction func emailAction(_ sender: Any) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        mailComposerVC.setToRecipients([(contact?.email)!])
        mailComposerVC.setSubject("Sending you an in-app e-mail...")
        mailComposerVC.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        AlertStandard.sharedInstance.showAlert(controller: self, title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.")
    }


    fileprivate func getContactForMore(){
        let headers:HTTPHeaders = ["hbbgvauth":"\(UserDefaultHelper.getToken()!)"]
        let apiClient = APIService.shared
        apiClient.getOwner(url: APIPaths().urlGetContact(), param: [:], header: headers) { (json, error) in
            self.contact = Contact(json: json!)
        }
    }
}
extension ConstactViewController:MFMailComposeViewControllerDelegate{
    
    // MARK: MFMailComposeViewControllerDelegate
     private func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: Error!) {
        controller.dismiss(animated: true, completion: nil)
        
    }
}
