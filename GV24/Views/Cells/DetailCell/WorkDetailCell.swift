//
//  WorkDetailCell.swift
//  GV24
//
//  Created by HuyNguyen on 6/2/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import IoniconsSwift
@objc protocol directRequestDelegate:class{
    @objc optional func chooseActionRequest()
}
@objc protocol OwnerDelegate:class{
    @objc optional func chooseActionOwner()
}
@objc protocol clickChooseWorkID:class{
    @objc optional func chooseAction()
}
@objc protocol chooseWorkDelegate:class {
    
    @objc optional func detailManagementDelegate()
}
class WorkDetailCell: CustomTableViewCell {
    @IBOutlet weak var topBtChoose: NSLayoutConstraint!
    @IBOutlet weak var heightHeader: NSLayoutConstraint!
    @IBOutlet weak var constraintChoose: NSLayoutConstraint!
    @IBOutlet weak var vSegment: UIView!
    @IBOutlet weak var constraintHeightButtonChoose: NSLayoutConstraint!
    @IBOutlet weak var imageName: UIImageView!
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var addressName: UILabel!
    @IBOutlet weak var btChoose: UIButton!
    weak var delegate:chooseWorkDelegate?
    weak var delegateWork:clickChooseWorkID?
    weak var ownerDelegate:OwnerDelegate?
    weak var delegateRequest:directRequestDelegate?
    @IBOutlet weak var aroundRight: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        imageName.layer.cornerRadius = imageName.frame.size.width/2
        imageName.clipsToBounds = true
        let image = Ionicons.chevronRight.image(15)
        aroundRight.setImage(image, for: .normal)
        aroundRight.tintColor = UIColor.colorWithRedValue(redValue: 187, greenValue: 187, blueValue: 193, alpha: 1)
        constraintHeightButtonChoose.constant = 0
        btChoose.isHidden = true
        vSegment.isHidden = true
        nameUser.font = UIFont(descriptor: UIFontDescriptor.MediumDescriptor(textStyle: UIFontTextStyle.body.rawValue), size: 17)
        addressName.font = UIFont(descriptor: UIFontDescriptor.preferredDescriptor(textStyle: UIFontTextStyle.headline.rawValue), size: 15)
        btChoose.titleLabel?.font = UIFont(descriptor: UIFontDescriptor.MediumDescriptor(textStyle: UIFontTextStyle.headline.rawValue), size: 15)
        btChoose.setTitleColor(UIColor.colorWithRedValue(redValue: 47, greenValue: 186, blueValue: 194, alpha: 1), for: .normal)
    }
    @IBAction func btDirectRequest(_ sender: Any) {
        if delegateRequest != nil {
            delegateRequest?.chooseActionRequest!()
        }
        if delegateWork != nil {
            delegateWork?.chooseAction!()
        }
    }
    @IBAction func btChooseAction(_ sender: Any) {
        
    }
    @IBAction func aroundRightAction(_ sender: Any) {
        if delegate != nil {
            delegate?.detailManagementDelegate!()
        }
        if ownerDelegate != nil {
            ownerDelegate?.chooseActionOwner!()
        }
    }
    
}
