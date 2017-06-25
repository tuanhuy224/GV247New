//
//  InfoDeatailCell.swift
//  GV24
//
//  Created by HuyNguyen on 6/2/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import IoniconsSwift
class InfoDetailCell: CustomTableViewCell {
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSubTitle: UILabel!
    @IBOutlet weak var lbComment: UILabel!
    @IBOutlet weak var imageMoney: UIImageView!
    @IBOutlet weak var lbMoney: UILabel!
    @IBOutlet weak var imageDate: UIImageView!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var imageAddress: UIImageView!
    @IBOutlet weak var lbAddress: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        imageAvatar.layer.cornerRadius = imageAvatar.frame.size.width/2
        imageAvatar.clipsToBounds = true
        imageMoney.backgroundColor = UIColor.clear
        imageDate.backgroundColor = UIColor.clear
        imageMoney.image = Ionicons.socialUsd.image(32).imageWithColor(color: UIColor.colorWithRedValue(redValue: 45, greenValue: 166, blueValue: 173, alpha: 1))
        imageDate.image = Ionicons.androidAlarmClock.image(32).imageWithColor(color: UIColor.colorWithRedValue(redValue: 45, greenValue: 166, blueValue: 173, alpha: 1))
        imageAddress.image = Ionicons.home.image(32).imageWithColor(color: UIColor.colorWithRedValue(redValue: 45, greenValue: 166, blueValue: 173, alpha: 1))
        lbTitle.font = UIFont(descriptor: UIFontDescriptor.MediumDescriptor(textStyle: UIFontTextStyle.body.rawValue), size: sizeSeven)
        lbSubTitle.font = UIFont(descriptor: UIFontDescriptor.RegularDescriptor(textStyle: UIFontTextStyle.footnote.rawValue), size: sizeFour)
        lbComment.font = UIFont(descriptor: UIFontDescriptor.RegularDescriptor(textStyle: UIFontTextStyle.footnote.rawValue), size: sizeFour)
        lbMoney.font = UIFont(descriptor: UIFontDescriptor.RegularDescriptor(textStyle: UIFontTextStyle.footnote.rawValue), size: sizeFour)
        lbDate.font = UIFont(descriptor: UIFontDescriptor.RegularDescriptor(textStyle: UIFontTextStyle.footnote.rawValue), size: sizeFour)
        lbTime.font = UIFont(descriptor: UIFontDescriptor.RegularDescriptor(textStyle: UIFontTextStyle.footnote.rawValue), size: sizeFour)
        lbAddress.font = UIFont(descriptor: UIFontDescriptor.RegularDescriptor(textStyle: UIFontTextStyle.footnote.rawValue), size: sizeFour)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
