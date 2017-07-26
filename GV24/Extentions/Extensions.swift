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
  var isPhoneNumber: Bool {
    do {
      let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
      let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.characters.count))
      if let res = matches.first {
        return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.characters.count
      } else {
        return false
      }
    } catch {
      return false
    }
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
