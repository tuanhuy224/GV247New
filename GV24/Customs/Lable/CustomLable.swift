//
//  CustomLAble.swift
//  GV24
//
//  Created by HuyNguyen on 6/25/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation

class CustomLable: UILabel {
    
    var subColor:UIColor
    var subMessage:String
    
    init(frame:CGRect,subColor:UIColor,subMessage:String){
        self.subColor = subColor
        self.subMessage = subMessage
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
