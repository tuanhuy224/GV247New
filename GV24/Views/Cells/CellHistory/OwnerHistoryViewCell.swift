//
//  OwnerTableViewCell.swift
//  GV24
//
//  Created by admin on 6/5/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import IoniconsSwift

class OwnerHistoryViewCell: UITableViewCell {

    var buttons:[UIButton]?
    @IBOutlet var btnRating: [UIButton]!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var arrowForward: UIImageView!
    @IBOutlet weak var workListButton: UIButton!
    @IBOutlet weak var ratingButton: UIButton!
    
    var imageFirst: UIImage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userImage.layer.cornerRadius = userImage.frame.size.width/2
        userImage.clipsToBounds = true
        let arrowForwardImage = Ionicons.iosArrowForward.image(12)
        arrowForward.image = arrowForwardImage
        
        imageFirst = Ionicons.iosStarOutline.image(32).maskWithColor(color: UIColor.colorWithRedValue(redValue: 249, greenValue: 187, blueValue: 67, alpha: 1))
        for i in btnRating {
            i.setImage(imageFirst, for: .normal)
        }
    }
    
    @IBAction func btnRatingAction(_ sender: UIButton) {
        let image = Ionicons.star.image(18).maskWithColor(color: UIColor.colorWithRedValue(redValue: 252, greenValue: 178, blueValue: 51, alpha: 1))
        let tag = sender.tag
        for i in btnRating {
            if i.tag <= tag {
                i.setImage(image, for: .normal)
            }
            else {
                i.setImage(imageFirst, for: .normal)
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
