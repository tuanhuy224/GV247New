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
    
    func imageWithColor(color: UIColor) -> UIImage? {
        var image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
}
extension UIBarButtonItem{
    
}



extension UIColor{
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    static func rgbAlpha(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    
}

class AppColor : NSObject{
    
    static let backgroundButtonHome = UIColor.rgb(red: 130, green: 130, blue: 130)
    static let backButton = UIColor.rgb(red: 19, green: 111, blue: 167)
    static let backGround = UIColor.white
    static let homeButton1 = UIColor.rgb(red: 255, green: 191, blue: 65)
    static let homeButton2 = UIColor.rgb(red: 95, green: 216, blue: 27)
    static let homeButton3 = UIColor.rgb(red: 6, green: 110, blue: 169)
    static let collection = UIColor.white /*UIColor.rgb(red: 216, green: 216, blue: 216)*/
    static let seqaratorView = UIColor.rgb(red: 230, green: 230, blue: 230)
    static let arrowRight = UIColor.rgb(red: 199, green: 199, blue: 204)
    static let white = UIColor.white
    static let lightGray = UIColor.lightGray
    static let icon = UIColor.lightGray
    static let facebook = UIColor.rgb(red: 65, green: 96, blue: 163)
    static let google = UIColor.rgb(red: 221, green: 74, blue: 56)
    static let colorButtonLogout = UIColor.rgb(red: 204, green: 204, blue: 204)
    static let titleButtonLogout = UIColor.rgb(red: 216, green: 216, blue: 216)
    static let buttonDelete = UIColor.rgb(red: 240, green: 19, blue: 77)
    static let successButton = UIColor.green
    static let unStart = UIColor.rgb(red: 249, green: 187, blue: 67)
    static let start = UIColor.rgb(red: 252, green: 178, blue: 81)
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
    
    static let colorButton: UIColor =  colorWithRedValue(redValue: 19, greenValue: 111, blueValue: 167, alpha: 1)
    
}

extension URLSession{
}

extension Date{
    static let dateFormatter = DateFormatter()
    init(isoDateString: String) {
        Date.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        Date.dateFormatter.timeZone = TimeZone(secondsFromGMT: 7)
        let newDate = Date.dateFormatter.date(from: isoDateString)
        self = newDate!
    }
    
    // convert date to string
    static func convertDateToString(date: String) -> String? {
        Date.dateFormatter.dateFormat = "HH:mm"
        
        let date = Date.dateFormatter.date(from: date)
        Date.dateFormatter.dateFormat = "hh:mm a"
        guard let dateData = date else {return ""}
        let Date12 = Date.dateFormatter.string(from: dateData)
        
        return Date12
    }
    
    // convert date to date
     func date(_ currentDate: Date) -> Date {
        Date.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        Date.dateFormatter.timeZone = TimeZone(secondsFromGMT: 7)
        let currentDateString = Date.dateFormatter.string(from: currentDate)
        let newDate = Date.dateFormatter.date(from: currentDateString)
        guard let date = newDate else { return Date()}
        return date
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
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
//        formatter.amSymbol = "AM".localize
//        formatter.pmSymbol = "PM".localize
        let hourMinute =  formatter.string(from: self)
        return hourMinute
    }
    var hourMinuteSecond: String{
        let calendar = Calendar(identifier: .gregorian)
        let hour = calendar.component(.hour, from: self)
        let minute = calendar.component(.minute, from: self)
        let second = calendar.component(.second, from: self)
        return "\(hour)h\(minute)p\(second)"
    }
    
    func date(datePost:String) -> DateComponents {
        let dateInsert = Date(isoDateString: datePost)
        let dateCurrent = Date()
        let calendar = NSCalendar.current
        let dateComponent = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dateInsert, to: dateCurrent)
        return dateComponent
    }
    

    func dateComPonent(datePost:String) -> String {
        if date(datePost: datePost).month! > 0 {
            return "\(date(datePost: datePost).month! )" + " " + "TimeMonth".localize
        }else if date(datePost: datePost).day! > 0{
            return "\(date(datePost: datePost).day! )" + " " + "TimeDay".localize
        }else if date(datePost: datePost).hour! > 0{
            return "\(date(datePost: datePost).hour! )" + " " + "TimeHour".localize
        }else if date(datePost: datePost).minute! > 0{
            return "\(date(datePost: datePost).minute! )" + " " + "TimeMinute".localize
        }else if date(datePost: datePost).second! > 0{
            return "\(date(datePost: datePost).second! )" + " " + "TimeSecond".localize
        }
        return ""
    }
    
    var comparse:Bool{
        switch self.compare(date(Date())) {
        case .orderedAscending:
            return true
        case .orderedDescending:
            return false
        default:
            return false
        }
    }
}
extension String {
    static func convertISODateToString(isoDateStr: String, format: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let newDate = dateFormatter.date(from: isoDateStr)
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: newDate!)
    }
    
    static func convertISODateToDate(isoDateStr: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let newDate = dateFormatter.date(from: isoDateStr)
        return newDate
    }
    
    static func convertDateToString(date: Date, withFormat: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = withFormat
        let newDateStr = dateFormatter.string(from: date)
        return newDateStr
    }
    
    static func convertDateToISODateType(date: Date) -> String?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let newISODateStr = dateFormatter.string(from: date)
        return newISODateStr
    }
}
extension UILabel{
    static func customLable(title:String, frame:CGRect) -> UILabel{
        return UILabel(frame: frame)
    }
}
extension Data {
    func hexString() -> String {
        return self.reduce("") { string, byte in
            string + String(format: "%02X", byte)
        }
    }
}


protocol pushnotifi {
    func pushviewcontroller()
}

//class OpenHomeBusinesss: pushnotifi {
//    let var1 = ...
//    let var2 = ...
//
//    init(var1)
//
//
func pushviewcontroller() {
    // creaete required controller
    // push to navigation
    // etc..
}

