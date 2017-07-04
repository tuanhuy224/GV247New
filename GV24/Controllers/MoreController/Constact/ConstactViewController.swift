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
    @IBOutlet weak var contentLabel: UILabel!
    
    let loadingIndicator = LoadingView()
    var contact:Contact! {
        didSet {
            if let contact = contact, let content = contact.address {
                contentLabel.text = content
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // fetch information for server side
        getContactForMore()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Contact".localize
        self.callPhone.setTitle("Call".localize, for: .normal)
    }
    
    func createComposer() -> MFMailComposeViewController? {
        guard let email = self.contact.email else {
            return nil
        }
        
        let controller = MFMailComposeViewController()
        controller.mailComposeDelegate = self
        controller.setToRecipients([email])
        controller.setSubject("Sending you an in-app e-mail...")
        controller.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)
        return controller
    }
    
    
    @IBAction func callPhoneAction(_ sender: Any) {
        if let phone = contact.phone, let url = NSURL(string: "tel://\(phone)"){
            UIApplication.shared.openURL(url as URL)
        }
    }

    @IBAction func emailAction(_ sender: Any) {
        
        guard let composer = createComposer() else { return }
        
        if MFMailComposeViewController.canSendMail() {
            self.present(composer, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func showSendMailErrorAlert() {
        AlertStandard.sharedInstance.showAlert(controller: self, title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.")
    }


    fileprivate func getContactForMore(){
        
        loadingIndicator.show()
        
        let headers:HTTPHeaders = ["hbbgvauth":"\(UserDefaultHelper.getToken()!)"]
        let apiClient = APIService.shared
        apiClient.getOwner(url: APIPaths().urlGetContact(), param: [:], header: headers) { [unowned self] (json, error) in
            self.contact = Contact(json: json!)
            self.loadingIndicator.close()
        }
    }
}



extension ConstactViewController: MFMailComposeViewControllerDelegate {
    
    // MARK: MFMailComposeViewControllerDelegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Swift.Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
