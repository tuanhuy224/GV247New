//
//  Extention+Image.swift
//  GV24
//
//  Created by HuyNguyen on 5/31/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import UIKit
import IoniconsSwift
extension UIButton {
    
}
extension UIImage {
    
    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!
        
        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
    
    // scale uiimage swift
    func scaleImage(_ newSize:CGSize) -> UIImage {
        
        // Core Graphic
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let result:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return result
    }
    
    func createRadius(_ newSize:CGSize, radius: CGFloat, byRoundingCorners: UIRectCorner?) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        
        let imgRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        if let roundingCorners = byRoundingCorners {
            
            UIBezierPath(roundedRect: imgRect, byRoundingCorners: roundingCorners, cornerRadii: CGSize(width: radius, height: radius)).addClip()
            
        } else {
            UIBezierPath(roundedRect: imgRect, cornerRadius: radius).addClip()
        }
        self .draw(in: imgRect)
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result!
    }
    
}
extension UIBarButtonItem{
    
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
    
    static func colorWithRedValue(redValue: CGFloat, greenValue: CGFloat, blueValue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: redValue/255.0, green: greenValue/255.0, blue: blueValue/255.0, alpha: alpha)
    }
}

extension URLSession{
}


extension Date{
    
    init(isoDateString: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        let date = dateFormatter.date(from: isoDateString)!
        self = date
    }
    var year : String{
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: self)
        return "\(year)"
    }
    var month: String{
        let calendar = Calendar(identifier: .gregorian)
        let month = calendar.component(.month, from: self)
        return "\(month)"
    }
    var day: String{
        let calendar = Calendar(identifier: .gregorian)
        let day = calendar.component(.day, from: self)
        return "\(day)"
    }
    var monthYear: String {
        let calendar = Calendar(identifier: .gregorian)
        let month = calendar.component(.month, from: self)
        let year = calendar.component(.year, from: self)
        return "\(month)/\(year)"
    }
    var dayMonthYear : String{
        let calendar = Calendar(identifier: .gregorian)
        let month = calendar.component(.month, from: self)
        let year = calendar.component(.year, from: self)
        let day = calendar.component(.day, from: self)
        return "\(day)/\(month)/\(year)"
    }
    
    var hour : String{
        let calendar = Calendar(identifier: .gregorian)
        let hour = calendar.component(.hour, from: self)
        return "\(hour)"
    }
    var minute: String{
        let calendar = Calendar(identifier: .gregorian)
        let minute = calendar.component(.minute, from: self)
        return "\(minute)"
    }
    var second: String{
        let calendar = Calendar(identifier: .gregorian)
        let second = calendar.component(.second, from: self)
        return "\(second)"
    }
    
    var hourMinute: String{
        let calendar = Calendar(identifier: .gregorian)
        let hour = calendar.component(.hour, from: self)
        let minute = calendar.component(.minute, from: self)
        return "\(hour)h\(minute)"
    }
    var hourMinuteSecond: String{
        let calendar = Calendar(identifier: .gregorian)
        let hour = calendar.component(.hour, from: self)
        let minute = calendar.component(.minute, from: self)
        let second = calendar.component(.second, from: self)
        return "\(hour)h\(minute)p\(second)"
    }
}




extension String {
    static func convertISODateToString(isoDateStr: String, format: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone.current
        let newDate = dateFormatter.date(from: isoDateStr)
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: newDate!)
    }
    
    static func convertISODateToDate(isoDateStr: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone.current
        let newDate = dateFormatter.date(from: isoDateStr)
        return newDate
    }
    
    static func convertDateToString(date: Date, withFormat: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = withFormat
        dateFormatter.timeZone = TimeZone.current
        let newDateStr = dateFormatter.string(from: date)
        return newDateStr
    }
    
    static func convertDateToISODateType(date: Date) -> String?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone.current
        let newISODateStr = dateFormatter.string(from: date)
        return newISODateStr
    }
}








