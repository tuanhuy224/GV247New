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
}
class FollowCell: CustomTableViewCell {
    @IBOutlet weak var btLogOut: UIButton!
    @IBOutlet weak var btIconRight2: UIButton!
    @IBOutlet weak var btIconRight: UIButton!
    @IBOutlet weak var lbFollow: UIButton!
    @IBOutlet weak var lbFacebook: UILabel!
    @IBOutlet weak var btFollow: UIButton!
    @IBOutlet weak var btFacebook: UIButton!
    weak var delegate:LogOutDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        btFollow.setImage(Ionicons.socialFacebookOutline.image(32), for: .normal)
        btFollow.tintColor = UIColor.colorWithRedValue(redValue: 47, greenValue: 186, blueValue: 194, alpha: 1)
        btFacebook.setImage(Ionicons.androidShareAlt.image(32), for: .normal)
        btFacebook.tintColor = UIColor.colorWithRedValue(redValue: 47, greenValue: 186, blueValue: 194, alpha: 1)
        lbFollow.tintColor = UIColor.colorWithRedValue(redValue: 47, greenValue: 186, blueValue: 194, alpha: 1)
        lbFacebook.tintColor = UIColor.colorWithRedValue(redValue: 47, greenValue: 186, blueValue: 194, alpha: 1)
        btIconRight.setImage(Ionicons.chevronRight.image(32), for: .normal)
        btIconRight.tintColor = UIColor.colorWithRedValue(redValue: 47, greenValue: 186, blueValue: 194, alpha: 1)
        btIconRight2.setImage(Ionicons.chevronRight.image(32), for: .normal)
        btIconRight2.tintColor = UIColor.colorWithRedValue(redValue: 47, greenValue: 186, blueValue: 194, alpha: 1)
        btLogOut.tintColor =  UIColor.colorWithRedValue(redValue: 253, greenValue: 189, blueValue: 78, alpha: 1)
        
    }
    @IBAction func btLogOutAction(_ sender: Any) {
        if delegate != nil {
            delegate?.logOut()
        }
    }
}
