//
//  fontSize.swift
//  GV24
//
//  Created by HuyNguyen on 6/30/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import IoniconsSwift
let imageFirst = Ionicons.androidStarOutline.image(32).maskWithColor(color: UIColor(red: 253/255, green: 179/255, blue: 53/255, alpha: 1))
public enum FontSizeText: String{
    
    case bold = "SFUIText-Bold"
    case boldItalic = "SFUIText-BoldItalic"
    case heavy = "SFUIText-Heavy"
    case heavyItalic = "SFUIText-HeavyItalic"
    case light = "SFUIText-Light"
    case lightItalic = "SFUIText-LightItalic"
    case medium = "SFUIText-Medium"
    case mediumItalic = "SFUIText-MediumItalic"
    case regular = "SFUIText-Regular"
    case regularItalic = "SFUIText-RegularItalic"
    case semibold = "SFUIText-Semibold"
    case semiboldItalic = "SFUIText-SemiboldItalic"
}

class fontSize: UIFont {
    static func fontName(name: FontSizeText, size: CGFloat)-> UIFont{
        return UIFont(name: name.rawValue, size: size)!
    }
}
