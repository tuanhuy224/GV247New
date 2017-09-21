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
    
    var work : Work? {
        didSet {
            
            btChoose.isHidden = true
            vSegment.isHidden = true
            constraintH.constant = 0
            btChooseConstraint.constant = 0
            lbOwner.text = "ownerInfor".localize
            nameUser.text = work?.stakeholders?.owner?.name
            addressName.text = work?.stakeholders?.owner?.address?.name
            guard let imag = self.work?.stakeholders?.owner?.image else {return}
            let url = URL(string: imag)
            if url == nil {
                self.imageName.image = UIImage(named: "avatar")
            }else{
                DispatchQueue.main.async {
                    self.imageName.kf.setImage(with: url)
                }
            }
        }
    }
    
    @IBOutlet weak var lbOwner: UILabel!
    @IBOutlet weak var btChooseConstraint: NSLayoutConstraint!
    @IBOutlet weak var constraintH: NSLayoutConstraint!
    @IBOutlet weak var btAction: UIButton!
    @IBOutlet weak var heightHeader: NSLayoutConstraint!
    @IBOutlet weak var vSegment: UIView!
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
        btChoose.isHidden = true
        vSegment.isHidden = true
        nameUser.font = fontSize.fontName(name: .medium, size: sizeSeven)
        addressName.font = fontSize.fontName(name: .regular, size: sizeFour)
        btChoose.titleLabel?.font = fontSize.fontName(name: .regular, size: sizeFive)
        btChoose.setTitleColor(AppColor.backButton, for: .normal)
        lbOwner.font = fontSize.fontName(name: .regular, size: sizeSix)
        
    }
    
    
    
    
    @IBAction func btDirectRequest(_ sender: Any) {
        if delegateRequest != nil {
            delegateRequest?.chooseActionRequest!()
        }
        if delegateWork != nil {
            delegateWork?.chooseAction!()
        }
    }
    
    @IBAction func customButtonRightClick(_ sender: Any) {
        if delegate != nil {
            delegate?.detailManagementDelegate!()
        }
        if ownerDelegate != nil {
            ownerDelegate?.chooseActionOwner!()
        }
        
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
