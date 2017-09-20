//
//  FollowCell.swift
//  GV24
//
//  Created by HuyNguyen on 6/19/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import IoniconsSwift

protocol LogOutDelegate:class {
    func logOut()
    func cellDidPressedShareToAirDrop(_ cell: FollowCell)
    func cellDidPressedShareToFacebook(_ cell: FollowCell)
}
class FollowCell: CustomTableViewCell {
    @IBOutlet weak var btLogOut: UIButton!
    @IBOutlet weak var btIconRight2: UIButton!
    @IBOutlet weak var btIconRight: UIButton!
    
    @IBOutlet weak var btFollowAc: UIButton!
    
    @IBOutlet weak var btFacebookAc: UIButton!
    @IBOutlet weak var btFollow: UIButton!
    @IBOutlet weak var btFacebook: UIButton!
    weak var delegate:LogOutDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        btFollow.setImage(Ionicons.socialFacebook.image(32), for: .normal)
        btFollow.tintColor = AppColor.backButton
        btFacebook.setImage(Ionicons.androidShareAlt.image(32), for: .normal)
        btFacebook.tintColor = AppColor.backButton
        btFollowAc.tintColor = AppColor.backButton
        btFacebookAc.tintColor = AppColor.backButton
        btIconRight.setImage(Ionicons.chevronRight.image(32), for: .normal)
        btIconRight.tintColor = AppColor.backButton
        btIconRight2.setImage(Ionicons.chevronRight.image(32), for: .normal)
        btIconRight2.tintColor = AppColor.backButton
        btLogOut.tintColor =  AppColor.backButton
        btLogOut.tintColor =  AppColor.backButton
        
        btFollowAc.addTarget(self, action: #selector(tapShareAirDropButton(_:)), for: .touchUpInside)
        btFacebookAc.addTarget(self, action: #selector(tapShareFacebookButton(_:)), for: .touchUpInside)
    }
    @IBAction func btLogOutAction(_ sender: Any) {
        if delegate != nil {
            delegate?.logOut()
        }
    }
    @IBAction func shareTap(_ sender: Any) {
        delegate?.cellDidPressedShareToAirDrop(self)
    }
    @IBAction func facebookTap(_ sender: Any) {
        delegate?.cellDidPressedShareToFacebook(self)
    }
    
    func tapShareAirDropButton(_ sender: UIButton) {
        delegate?.cellDidPressedShareToAirDrop(self)
    }
    
    func tapShareFacebookButton(_ sender: UIButton) {
        delegate?.cellDidPressedShareToFacebook(self)
    }
}
