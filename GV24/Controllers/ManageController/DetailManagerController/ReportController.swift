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
  @IBOutlet weak var viewTextView: UIView!
  @IBOutlet weak var imageProfile: UIImageView!
  @IBOutlet weak var nameProfile: UILabel!
  @IBOutlet weak var addressProfile: UILabel!
  var work = Work()
  var text:String?{
    didSet{
      rp.text = text
    }
  }
  var placeholder = "Pleasefillinthereport".localize
  @IBOutlet weak var rp: UITextView!{
    didSet {
      rp.textColor = UIColor.lightGray
      rp.text = placeholder
      rp.selectedRange = NSRange(location: 0, length: 0)
    }
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupView()
    rp.delegate = self
  }
  override func setupViewBase() {
    super.setupViewBase()
    self.navigationItem.title = "report".localize
  }
  func setupView()  {
    nameProfile.font = UIFont(descriptor: UIFontDescriptor.MediumDescriptor(textStyle: UIFontTextStyle.body.rawValue), size: sizeSeven)
    addressProfile.font = UIFont(descriptor: UIFontDescriptor.preferredDescriptor(textStyle: UIFontTextStyle.footnote.rawValue), size: sizeFour)
    imageProfile.layer.cornerRadius = imageProfile.frame.size.width/2
    imageProfile.clipsToBounds = true
    nameProfile.text = work.stakeholders?.owner?.name
    addressProfile.text = work.stakeholders?.owner?.address?.name
    let url = URL(string: (work.stakeholders?.owner?.image)!)
    if url == nil {
      self.imageProfile.image = UIImage(named: "avatar")
    }else{
      DispatchQueue.main.async {
        self.imageProfile.kf.setImage(with: url)
      }
    }
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send".localize, style: .plain, target: self, action: #selector(ReportController.addTapped))
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ReportController.dismissKeyboard))
    view.addGestureRecognizer(tap)
  }
  
  
  func applyPlaceholderStyle(aTextview: UITextView, placeholderText: String){
    aTextview.textColor = .lightGray
    aTextview.text = placeholderText
  }
  
  func applyNonPlaceholderStyle(aTextview: UITextView){
    aTextview.textColor = .darkText
    aTextview.alpha = 1.0
  }
  
  func moveCursorToStart(aTextView: UITextView){
    DispatchQueue.main.async(execute: {
      aTextView.selectedRange = NSMakeRange(0, 0);
    })
  }
  
  
  func dismissKeyboard() {
    view.endEditing(true)
  }
  func addTapped() {
    guard let token = UserDefaultHelper.getToken() else{return}
    let headers:HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded","hbbgvauth":token]
    guard let id = work.stakeholders?.owner?.id else{return}
    guard let content = text else{
      AlertStandard.sharedInstance.showAlert(controller: self, title: "", message: "Pleasefillinthereport".localize)
      return
    }
      self.loadingView.show()
      let param:Parameters = ["toId":id,"content":content]
      let apiClient = APIService.shared
      apiClient.postReserve(url: APIPaths().maidReport(), method: .post, parameters: param, header: headers) { (json, message) in
        self.loadingView.close()
        if message == "SUCCESS"{
          AlertStandard.sharedInstance.showAlertPopToView(controller: self, title: "", message: "Reportsentsuccessfully".localize)
        }
      }
  }
}
extension ReportController: UITextViewDelegate {
  
  func textViewShouldBeginEditing(aTextView: UITextView) -> Bool{
    if aTextView == aTextView && aTextView.text == "Pleasefillinthereport".localize{
      //moveCursorToStart(aTextView: aTextView)
    }
    return true
  }
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    let newLength = textView.text.utf16.count + text.utf16.count - range.length
    if newLength > 0{
      self.text = textView.text
      if textView == rp && textView.text == "Pleasefillinthereport".localize{
        if text.utf16.count == 0{
          return false
        }
        applyNonPlaceholderStyle(aTextview: textView)
        textView.text = ""
      }
      return true
    }else{
      applyPlaceholderStyle(aTextview: textView, placeholderText: "Pleasefillinthereport".localize)
      moveCursorToStart(aTextView: textView)
      return false
    }
  }
}
