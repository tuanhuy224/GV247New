//
//  MoreCell.swift
//  GV24
//
//  Created by HuyNguyen on 5/30/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import IoniconsSwift

class MoreCell: CustomTableViewCell {

    @IBOutlet weak var imgMore: UIImageView!
    @IBOutlet weak var lbMore: UILabel!
    @IBOutlet weak var iconRight: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let icon = Ionicons.chevronRight.image(32).maskWithColor(color: AppColor.backButton)
        iconRight.setImage(icon, for: .normal)
        cornerImage(imgMore, 4)
    }
    func cornerImage(_ img: UIImageView, _ radius: CGFloat) {
        img.layer.cornerRadius = radius
        img.clipsToBounds = true
    }
}
