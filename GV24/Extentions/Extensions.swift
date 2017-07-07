//
//  Extensions.swift
//  GV24
//
//  Created by Macbook Solution on 7/4/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation


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

}
