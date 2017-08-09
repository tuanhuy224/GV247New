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
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
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
