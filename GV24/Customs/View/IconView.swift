
//  IconView.swift
//  GV24
//
//  Created by dinhphong on 8/28/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import UIKit
import IoniconsSwift

class IconView: UIImageView {
    
    init(icon : Ionicons,size : CGFloat) {
        super.init(frame: .zero)
        setUp(size: size)
        contentMode = .scaleAspectFit
        image = Icon.by(name: icon)
    }
    init(icon : Ionicons,size : CGFloat, color : UIColor) {
        super.init(frame: .zero)
        setUp(size: size)
        contentMode = .scaleAspectFit
        image = Icon.by(name: icon, color: color)
    }
    init(image : String, size : CGFloat) {
        super.init(frame: .zero)
        setUp(size: size)
        contentMode = .scaleAspectFit
        self.image = Icon.by(imageName: image)
    }
    init(size: CGFloat){
        super.init(frame: .zero)
        setUp(size: size)
        contentMode = .scaleAspectFit
    }
    
    func setUp(size: CGFloat){
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: size).isActive = true
        widthAnchor.constraint(equalToConstant: size).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
