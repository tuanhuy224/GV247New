//
//  InfoCommentCell.swift
//  GV24
//
//  Created by Macbook Solution on 6/20/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import IoniconsSwift

class InfoCommentCell: CustomTableViewCell {
    @IBOutlet var btRating: [UIButton]!
    var buttons:[UIButton]?
    var star:UIImage?
    var unstar:UIImage?
    @IBOutlet weak var workTitle: UILabel!
    @IBOutlet weak var topLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var createAtLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        topLabel.text = "Assessment".localize.uppercased()
        imageAvatar.layer.cornerRadius = imageAvatar.frame.size.width/2
        imageAvatar.clipsToBounds = true
        //content.font = UIFont(fontSize()
        unstar = Ionicons.iosStarOutline.image(16).maskWithColor(color: UIColor(red: 253/255, green: 179/255, blue: 53/255, alpha: 1))
        star = Ionicons.star.image(16).maskWithColor(color: UIColor(red: 253/255, green: 179/255, blue: 53/255, alpha: 1))
        for i in btRating {
            i.setImage(star, for: .normal)
        }
        userName.font = UIFont(descriptor: UIFontDescriptor.BoldDescriptor(textStyle: UIFontTextStyle.body.rawValue), size: 17)
        topLabel.font = UIFont(descriptor: UIFontDescriptor.preferredDescriptor(textStyle: UIFontTextStyle.headline.rawValue), size: 17)
        workTitle.font = UIFont(descriptor: UIFontDescriptor.preferredDescriptor(textStyle: UIFontTextStyle.headline.rawValue), size: 15)
        content.font = UIFont(descriptor: UIFontDescriptor.preferredDescriptor(textStyle: UIFontTextStyle.headline.rawValue), size: 15)
        createAtLabel.font = UIFont(descriptor: UIFontDescriptor.preferredDescriptor(textStyle: UIFontTextStyle.headline.rawValue), size: 14)
    }
    
    @IBAction func btRatingAction(_ sender: UIButton) {
        let tag = sender.tag
        for i in btRating{
            if i.tag <= tag {
                i.setImage(star, for: .normal)
            }else{
                i.setImage(unstar, for: .normal)
            }
        }
    }
}
