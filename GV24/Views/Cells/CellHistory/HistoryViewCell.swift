//
//  HistoryViewCell.swift
//  GV24
//
//  Created by HuyNguyen on 5/29/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import IoniconsSwift

class HistoryViewCell: CustomTableViewCell {
    @IBOutlet weak var lbDeadline: UILabel!
    @IBOutlet weak var lbTimePost: UILabel!
    @IBOutlet weak var lbDist: UILabel!
    @IBOutlet weak var btImage: UIButton!
    @IBOutlet weak var timeWork: UILabel!
    @IBOutlet weak var createdDate: UILabel!
    @IBOutlet weak var workNameLabel: UILabel!
    @IBOutlet weak var estimateWorkTime: UILabel!
    @IBOutlet weak var iconAlarm: UIImageView!{
        didSet{
            let icon = Ionicons.androidAlarmClock.image(32).imageWithColor(color: UIColor.colorWithRedValue(redValue: 45, greenValue: 166, blueValue: 173, alpha: 1))
            btImage.setImage(icon, for: .normal)
        }
    }
    @IBOutlet weak var imageWork: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    func setupCell() {
        imageWork.layer.cornerRadius = imageWork.frame.width/2
        imageWork.clipsToBounds = true
        lbDeadline.layer.cornerRadius = 6
        lbDeadline.clipsToBounds = true
        workNameLabel.font = UIFont(descriptor: UIFontDescriptor.MediumDescriptor(textStyle: UIFontTextStyle.subheadline.rawValue), size: sizeSeven)
        lbDeadline.font = UIFont(descriptor: UIFontDescriptor.preferredDescriptor(textStyle: UIFontTextStyle.subheadline.rawValue), size: sizeThree)
        lbDist.font = UIFont(descriptor: UIFontDescriptor.RegularDescriptor(textStyle: UIFontTextStyle.footnote.rawValue), size: sizeTwo)
        timeWork.font = UIFont(descriptor: UIFontDescriptor.RegularDescriptor(textStyle: UIFontTextStyle.footnote.rawValue), size: sizeTwo)
        lbTimePost.font = UIFont(descriptor: UIFontDescriptor.RegularDescriptor(textStyle: UIFontTextStyle.footnote.rawValue), size: sizeTwo)
        lbDeadline.font = UIFont(descriptor: UIFontDescriptor.RegularDescriptor(textStyle: UIFontTextStyle.footnote.rawValue), size: sizeThree)
        lbDeadline.isHidden = true
    }

}
