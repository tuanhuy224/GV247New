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
            setupView()
        tfReport.delegate = self
    }
    override func setupViewBase() {
        super.setupViewBase()
        self.navigationItem.title = "Feedback".localize
    }
    func setupView()  {
        let placeholderTextView = KMPlaceholderTextView(frame: view.bounds)
        placeholderTextView.placeholder = "Pleasefillinthereport".localize
        view.addSubview(placeholderTextView)
        nameProfile.font = UIFont(descriptor: UIFontDescriptor.MediumDescriptor(textStyle: UIFontTextStyle.body.rawValue), size: sizeSeven)
        addressProfile.font = UIFont(descriptor: UIFontDescriptor.preferredDescriptor(textStyle: UIFontTextStyle.footnote.rawValue), size: sizeFour)
        imageProfile.layer.cornerRadius = imageProfile.frame.size.width/2
        imageProfile.clipsToBounds = true
        nameProfile.text = work.stakeholders?.owner?.username
        addressProfile.text = work.stakeholders?.owner?.address?.name
        let url = URL(string: (work.stakeholders?.owner?.image)!)
        if url == nil {
            DispatchQueue.main.async {
                self.imageProfile.image = UIImage(named: "avatar")
            }
        }else{
            DispatchQueue.main.async {
                self.imageProfile.kf.setImage(with: url)
            }
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send".localize, style: .plain, target: self, action: #selector(ReportController.addTapped))
    }
    func addTapped() {
        let headers:HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded","hbbgvauth":"\(UserDefaultHelper.getToken()!)"]
        let param:Parameters = ["toId":"\(work.stakeholders!.owner!.id!)","content":tfReport.text]
        let apiClient = APIService.shared
            apiClient.postReserve(url: APIPaths().maidReport(), method: .post, parameters: param, header: headers) { (json, message) in
                if message == "SUCCESS"{
                    AlertStandard.sharedInstance.showAlertPopToView(controller: self, title: "", message: "Reportsentsuccessfully".localize)
                }
        }
    }
}
extension ReportController:UITextViewDelegate{
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
}
