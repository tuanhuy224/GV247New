//
//  MoreCell.swift
//  GV24
//
//  Created by HuyNguyen on 5/30/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import IoniconsSwift

class MoreCell: UITableViewCell {

    @IBOutlet weak var lbMore: UILabel!
    @IBOutlet weak var iconRight: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let icon = Ionicons.chevronRight.image(12)
        iconRight.setImage(icon, for: .normal)
        iconRight.tintColor = UIColor.colorWithRedValue(redValue: 47, greenValue: 186, blueValue: 194, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
