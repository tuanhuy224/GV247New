//
//  TableViewHelper.swift
//  GV24
//
//  Created by Macbook Solution on 6/15/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import UIKit

class TableViewHelper: NSObject {
    
    func emptyMessage(message: String, size:CGSize) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width:size.width, height: size.height))
        label.text = message
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont(name: "TrebuchetMS", size: 17)
        label.sizeToFit()
        return label
    }
}
