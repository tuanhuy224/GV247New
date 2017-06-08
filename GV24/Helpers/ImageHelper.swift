//
//  ImageHelper.swift
//  Glam.HieuDaiKy
//
//  Created by DaiVP on 5/19/16.
//  Copyright © 2016 Ky Nguyen. All rights reserved.
//

import UIKit

extension UIImage {
    
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
