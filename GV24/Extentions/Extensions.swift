//
//  Extensions.swift
//  GV24
//
//  Created by Macbook Solution on 7/4/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import IoniconsSwift


//------------------ 3rd Party - Model ------------------//



extension Locale {
    
    func IOSLanguageCode() -> String? {
//        print("languageCode:\(languageCode ?? "nil"), countryCode:\(countryCode ?? "nil")")
        guard let languageCode = languageCode, let countryCode = countryCode else {
            return nil
        }
        return "\(languageCode)-\(countryCode)"
    }
    
}


//------------------ OS - UIKit ------------------//
extension String {
    
     func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [], attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
    
     func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: [], attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.width
    }
  
  //Validate Email
  var isEmail: Bool {
    do {
      let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
      return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
    } catch {
      return false
    }
  }
  
  //validate PhoneNumber
    var isPhoneNumber : Bool {
        let mobileFormat = "^(\\+\\d{1,3}[- ]?)?\\d{10,11}$"
        
        let mobileTest = NSPredicate(format: "SELF MATCHES %@", mobileFormat)
        let mobileTestResult = mobileTest.evaluate(with: self)
        if !mobileTestResult {
            return false
        }
        return true
    }
    
    func numberFormat(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        numberFormatter.groupingSeparator = "."
        let formattedNumber = numberFormatter.string(from: NSNumber(value:number))
        return formattedNumber!
    }

}

extension UIButton{

  override open var isSelected: Bool{
    didSet{
      if isSelected == true {
        //self.setImage(Icon.by(name: .iosStar, color: AppColor.homeButton1), for: .normal)
      }else{
       // self.setImage(Icon.by(name: .iosStarOutline, color: AppColor.homeButton1), for: .normal)
      }
    }
  }

}

extension UILabel {
 
    static func cornerLable(lb: UILabel, radius: CGFloat){
        lb.layer.cornerRadius = radius
        lb.layer.masksToBounds = true
    }
}
extension UIButton {
    
    static func cornerButton(bt: UIButton, radius: CGFloat){
        bt.layer.cornerRadius = radius
        bt.layer.masksToBounds = true
    }
}

extension UIImageView{

    static func cornerImage(img: UIImageView, radius: CGFloat){
        img.layer.cornerRadius = radius
        img.layer.masksToBounds = true
    }
}

extension NSMutableAttributedString {
    @discardableResult func bold(_ text:String) -> NSMutableAttributedString {
        let attrs:[String:AnyObject] = [NSFontAttributeName : fontSize.fontName(name: .bold, size: 16)]
        let boldString = NSMutableAttributedString(string:"\(text)", attributes:attrs)
        self.append(boldString)
        return self
    }
    
    @discardableResult func normal(_ text:String)->NSMutableAttributedString {
        let normal =  NSAttributedString(string: text)
        self.append(normal)
        return self
    }
}

extension UIView {
    func addConstraintWithFormat(format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated(){
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }

    
    static func verticalLine(height : CGFloat) -> UIView{
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.widthAnchor.constraint(equalToConstant: 1).isActive = true
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
        return view
    }

}
