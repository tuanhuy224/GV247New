//
//  StatisticCell.swift
//  GV24
//
//  Created by Macbook Solution on 6/23/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import IoniconsSwift

class StatisticCell: UITableViewCell {

    var buttons:[UIButton]?
    @IBOutlet var btnRating: [UIButton]!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var unstar: UIImage = {
        let img = Ionicons.iosStarOutline.image(32).maskWithColor(color: UIColor.colorWithRedValue(redValue: 249, greenValue: 187, blueValue: 67, alpha: 1))
        return img!
    }()
    var star: UIImage = {
        let img = Ionicons.star.image(18).maskWithColor(color: UIColor.colorWithRedValue(redValue: 252, greenValue: 178, blueValue: 51, alpha: 1))
        return img!
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    func setupCell() {
        userImage.layer.cornerRadius = userImage.frame.size.width/2
        userImage.clipsToBounds = true
        for i in btnRating {
            i.setImage(self.star, for: .normal)
        }
    }
    
    @IBAction func btnRatingAction(_ sender: UIButton) {
        let tag = sender.tag
        for i in btnRating {
            if i.tag <= tag {
                i.setImage(star, for: .normal)
            }
            else {
                i.setImage(unstar, for: .normal)
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
