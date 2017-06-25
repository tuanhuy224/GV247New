//
//  ChangeFontSize.swift
//  GV24
//
//  Created by HuyNguyen on 6/23/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation

extension UIFontDescriptor {
    
    private struct SubStruct {
        static var preferredFontName: String = "SFUIText-Light"
        static var MediumFontName: String = "SFUIText-Medium"
        static var LightFontName: String = "SFUIText-Light"
        static var RegularFontName: String = "SFUIText-Regular"
        static var SimiBoldFontName:String = "SFUIText-Semibold"
    }
    
    static let fontSizeTable : NSDictionary = [
        UIFontTextStyle.headline: [
            UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 23,
            UIContentSizeCategory.accessibilityExtraExtraLarge: 23,
            UIContentSizeCategory.accessibilityExtraLarge: 23,
            UIContentSizeCategory.accessibilityLarge: 23,
            UIContentSizeCategory.accessibilityMedium: 23,
            UIContentSizeCategory.extraExtraExtraLarge: 23,
            UIContentSizeCategory.extraExtraLarge: 21,
            UIContentSizeCategory.extraLarge: 19,
            UIContentSizeCategory.large: 17,
            UIContentSizeCategory.medium: 16,
            UIContentSizeCategory.small: 15,
            UIContentSizeCategory.extraSmall: 14
        ],
        UIFontTextStyle.subheadline: [
            UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 21,
            UIContentSizeCategory.accessibilityExtraExtraLarge: 21,
            UIContentSizeCategory.accessibilityExtraLarge: 21,
            UIContentSizeCategory.accessibilityLarge: 21,
            UIContentSizeCategory.accessibilityMedium: 21,
            UIContentSizeCategory.extraExtraExtraLarge: 21,
            UIContentSizeCategory.extraExtraLarge: 19,
            UIContentSizeCategory.extraLarge: 17,
            UIContentSizeCategory.large: 15,
            UIContentSizeCategory.medium: 14,
            UIContentSizeCategory.small: 13,
            UIContentSizeCategory.extraSmall: 12
        ],
        UIFontTextStyle.body: [
            UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 53,
            UIContentSizeCategory.accessibilityExtraExtraLarge: 47,
            UIContentSizeCategory.accessibilityExtraLarge: 40,
            UIContentSizeCategory.accessibilityLarge: 33,
            UIContentSizeCategory.accessibilityMedium: 28,
            UIContentSizeCategory.extraExtraExtraLarge: 23,
            UIContentSizeCategory.extraExtraLarge: 21,
            UIContentSizeCategory.extraLarge: 19,
            UIContentSizeCategory.large: 17,
            UIContentSizeCategory.medium: 16,
            UIContentSizeCategory.small: 15,
            UIContentSizeCategory.extraSmall: 14
        ],
        UIFontTextStyle.caption1: [
            UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 18,
            UIContentSizeCategory.accessibilityExtraExtraLarge: 18,
            UIContentSizeCategory.accessibilityExtraLarge: 18,
            UIContentSizeCategory.accessibilityLarge: 18,
            UIContentSizeCategory.accessibilityMedium: 18,
            UIContentSizeCategory.extraExtraExtraLarge: 18,
            UIContentSizeCategory.extraExtraLarge: 16,
            UIContentSizeCategory.extraLarge: 14,
            UIContentSizeCategory.large: 12,
            UIContentSizeCategory.medium: 11,
            UIContentSizeCategory.small: 11,
            UIContentSizeCategory.extraSmall: 11
        ],
        UIFontTextStyle.caption2: [
            UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 17,
            UIContentSizeCategory.accessibilityExtraExtraLarge: 17,
            UIContentSizeCategory.accessibilityExtraLarge: 17,
            UIContentSizeCategory.accessibilityLarge: 17,
            UIContentSizeCategory.accessibilityMedium: 17,
            UIContentSizeCategory.extraExtraExtraLarge: 17,
            UIContentSizeCategory.extraExtraLarge: 15,
            UIContentSizeCategory.extraLarge: 13,
            UIContentSizeCategory.large: 11,
            UIContentSizeCategory.medium: 11,
            UIContentSizeCategory.small: 11,
            UIContentSizeCategory.extraSmall: 11
        ],
        UIFontTextStyle.footnote: [
            UIContentSizeCategory.accessibilityExtraExtraExtraLarge: 19,
            UIContentSizeCategory.accessibilityExtraExtraLarge: 19,
            UIContentSizeCategory.accessibilityExtraLarge: 19,
            UIContentSizeCategory.accessibilityLarge: 19,
            UIContentSizeCategory.accessibilityMedium: 19,
            UIContentSizeCategory.extraExtraExtraLarge: 19,
            UIContentSizeCategory.extraExtraLarge: 17,
            UIContentSizeCategory.extraLarge: 15,
            UIContentSizeCategory.large: 13,
            UIContentSizeCategory.medium: 12,
            UIContentSizeCategory.small: 12,
            UIContentSizeCategory.extraSmall: 12
        ],
        ]
    
    final class func preferredDescriptor(textStyle: String) -> UIFontDescriptor {
        
        let contentSize = UIApplication.shared.preferredContentSizeCategory
        let style = fontSizeTable[textStyle] as! NSDictionary
        return UIFontDescriptor(name: SubStruct.preferredFontName, size: CGFloat((style[contentSize] as! NSNumber).floatValue))
    }
    final class func MediumDescriptor(textStyle: String) -> UIFontDescriptor {
        
        let contentSize = UIApplication.shared.preferredContentSizeCategory
        let style = fontSizeTable[textStyle] as! NSDictionary
        return UIFontDescriptor(name: SubStruct.MediumFontName, size: CGFloat((style[contentSize] as! NSNumber).floatValue))
    }
    final class func RegularDescriptor(textStyle: String) -> UIFontDescriptor {
        let contentSize = UIApplication.shared.preferredContentSizeCategory
        let style = fontSizeTable[textStyle] as! NSDictionary
        return UIFontDescriptor(name: SubStruct.RegularFontName, size: CGFloat((style[contentSize] as! NSNumber).floatValue))
    }
    final class func SemiBoldDescriptor(textStyle: String) -> UIFontDescriptor {
        let contentSize = UIApplication.shared.preferredContentSizeCategory
        let style = fontSizeTable[textStyle] as! NSDictionary
        return UIFontDescriptor(name: SubStruct.SimiBoldFontName, size: CGFloat((style[contentSize] as! NSNumber).floatValue))
    }
    
}
