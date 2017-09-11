//
//  MarkerInfoWindow.swift
//  GV24
//
//  Created by dinhphong on 9/5/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import UIKit



class MarkerInfoWindow: UIView {
    
    var info: Info? {
        didSet{
            if let info = info {
                 workTypeImage.kf.setImage(with: URL(string: (info.workName?.image!)!), placeholder: UIImage(named: "nau an"), options: nil, progressBlock: nil, completionHandler: nil)
                labelName.text = info.title
            }
        }
    }
    
    let margin : CGFloat = 5.0
    private let workTypeImage : UIImageView = {
        let iconSize : CGFloat = 40
        let iv = UIImageView(image : UIImage(named: "nau an"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.widthAnchor.constraint(equalToConstant: iconSize).isActive = true
        iv.heightAnchor.constraint(equalToConstant: iconSize).isActive = true
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = iconSize/2
        return iv
    }()
    
    private let labelName : UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.numberOfLines = 0
        lb.font = UIFont(name: "SFUIText-Medium", size: 14)
        lb.text = "Nguyễn Văn A"
        return lb
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView() {
        backgroundColor = UIColor.white
        addSubview(workTypeImage)
        addSubview(labelName)
        
        workTypeImage.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        workTypeImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: margin).isActive = true
        
        labelName.leftAnchor.constraint(equalTo: workTypeImage.rightAnchor, constant: margin).isActive = true
        labelName.centerYAnchor.constraint(equalTo: workTypeImage.centerYAnchor, constant: 0).isActive = true
        labelName.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 5).isActive = true
        
        
    }
}
