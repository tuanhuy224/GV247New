//
//  WorkDetailCell.swift
//  GV24
//
//  Created by HuyNguyen on 6/2/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import IoniconsSwift

class WorkDetailCell: UITableViewCell {
    @IBOutlet weak var imageName: UIImageView!
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var addressName: UILabel!
    @IBOutlet weak var btChoose: UIButton!

    @IBOutlet weak var aroundRight: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        imageName.layer.cornerRadius = imageName.frame.size.width/2
        imageName.clipsToBounds = true
        let image = Ionicons.chevronRight.image(15)
        aroundRight.setImage(image, for: .normal)
        aroundRight.tintColor = UIColor.colorWithRedValue(redValue: 187, greenValue: 187, blueValue: 193, alpha: 1)
    }
    @IBAction func btChooseAction(_ sender: Any) {
    }
    @IBAction func aroundRightAction(_ sender: Any) {
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
