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
    
    @IBOutlet weak var lbNameCompany: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var callPhone: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var contentLabel: UILabel!
    
    let loadingIndicator = LoadingView()
    var contact: Contact? {
        didSet {
            if let contact = contact, let content = contact.address {
                contentLabel.text = content
                lbNameCompany.text = contact.name
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
        lbAddress.text = "Address".localize
    
    }
    
    func createComposer() -> MFMailComposeViewController? {
        guard let email = self.contact?.email else {
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
        guard let phone = contact?.phone else{
            return AlertStandard.sharedInstance.showAlert(controller: self, title: "", message: "Nointernetconnection".localize)
        }
        guard let url = NSURL(string: "tel://\(phone)") else {return}
        UIApplication.shared.openURL(url as URL)
        
        
    }
    
    @IBAction func emailAction(_ sender: Any) {
        
        guard let composer = createComposer() else {
            return AlertStandard.sharedInstance.showAlert(controller: self, title: "", message: "Nointernetconnection".localize)
        }
        
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
        guard let token = UserDefaultHelper.getToken() else {return}
        let headers:HTTPHeaders = ["hbbgvauth":"\(token)"]
        let apiClient = APIService.shared
        apiClient.getOwner(url: APIPaths().urlGetContact(), param: [:], header: headers) { [unowned self] (json, error) in
            self.loadingIndicator.close()
            guard let jsonData = json else {return}
            self.contact = Contact(json: jsonData)
            
        }
    }
}



extension ConstactViewController: MFMailComposeViewControllerDelegate {
    
    // MARK: MFMailComposeViewControllerDelegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Swift.Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
