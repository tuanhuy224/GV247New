//
//  WaittingCell.swift
//  GV24
//
//  Created by HuyNguyen on 6/5/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import IoniconsSwift

class WaittingCell: UITableViewCell {

    @IBOutlet weak var btCancel: UIButton!
    @IBOutlet weak var lbCancel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        let image = Ionicons.iosTrash.image(24)
        btCancel.setImage(image, for: .normal)
        btCancel.tintColor = UIColor.colorWithRedValue(redValue: 252, greenValue: 178, blueValue: 52, alpha: 1)
        lbCancel.textColor = UIColor.colorWithRedValue(redValue: 252, greenValue: 178, blueValue: 52, alpha: 1)
    }
    //252 178 52
    @IBAction func btCancelAction(_ sender: Any) {
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
