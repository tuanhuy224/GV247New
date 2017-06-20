//
//  NotifiCell.swift
//  GV24
//
//  Created by HuyNguyen on 5/30/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import IoniconsSwift
@objc protocol changeLanguageDelegate:class {
   @objc optional func changeLanguage()
}
class NotifiCell: CustomTableViewCell {
    @IBOutlet weak var btChoose: UIButton!
    @IBOutlet weak var btChooseLanguage: UIButton!
    @IBOutlet weak var lbNotif: UILabel!
    @IBOutlet weak var switchNoti: UISwitch!
    weak var delegate:changeLanguageDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        let image = Ionicons.chevronRight.image(32)
        btChoose.setImage(image, for: .normal)
        btChoose.tintColor = UIColor.colorWithRedValue(redValue: 47, greenValue: 186, blueValue: 194, alpha: 1)
    }

    @IBAction func btChooseLanguageAction(_ sender: Any) {
        if delegate != nil {
            delegate?.changeLanguage!()
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
