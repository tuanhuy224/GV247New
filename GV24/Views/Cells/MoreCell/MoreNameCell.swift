//
//  MoreNameCell.swift
//  GV24
//
//  Created by HuyNguyen on 5/30/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import IoniconsSwift

class MoreNameCell: UITableViewCell {
   var user:User?
    @IBOutlet weak var iconLeft: UIButton!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var address: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        user = UserDefaultHelper.currentUser
        userName.text = user?.username
        address.text = user?.address?.name
        let icon = Ionicons.chevronRight.image(12)
        iconLeft.setImage(icon, for: .normal)
        iconLeft.tintColor = UIColor.colorWithRedValue(redValue: 47, greenValue: 186, blueValue: 194, alpha: 1)
        avatar.layer.cornerRadius = avatar.frame.size.width/2
        avatar.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
