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
  @IBOutlet weak var contraintWidthDeadline: NSLayoutConstraint!
    @IBOutlet weak var toolConstraint: NSLayoutConstraint!
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var lbTools: UILabel!
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
    @IBOutlet weak var lbdeadLine: UILabel!{
    didSet{
    lbdeadLine.textAlignment = .center
    }
  }
    @IBOutlet weak var constraintDescription: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        lbTools.isHidden = true
        //toolConstraint.constant = 0
        lbTools.font = fontSize.fontName(name: .regular, size: sizeFive)
        lbTools.textColor = UIColor.colorWithRedValue(redValue: 45, greenValue: 166, blueValue: 173, alpha: 1)
        imageAvatar.layer.cornerRadius = imageAvatar.frame.size.width/2
        imageAvatar.clipsToBounds = true
        imageMoney.backgroundColor = UIColor.clear
        imageDate.backgroundColor = UIColor.clear
        imageMoney.image = Ionicons.socialUsd.image(32).imageWithColor(color: UIColor.colorWithRedValue(redValue: 45, greenValue: 166, blueValue: 173, alpha: 1))
        imageDate.image = Ionicons.androidAlarmClock.image(32).imageWithColor(color: UIColor.colorWithRedValue(redValue: 45, greenValue: 166, blueValue: 173, alpha: 1))
        imageAddress.image = Ionicons.home.image(32).imageWithColor(color: UIColor.colorWithRedValue(redValue: 45, greenValue: 166, blueValue: 173, alpha: 1))
        lbTitle.font = fontSize.fontName(name: .bold, size: sizeSeven)
        lbSubTitle.font = fontSize.fontName(name: .regular, size: sizeFour)
        lbComment.font = fontSize.fontName(name: .regular, size: sizeFour)
        lbMoney.font = fontSize.fontName(name: .regular, size: sizeFour)
        lbDate.font = fontSize.fontName(name: .regular, size: sizeFour)
        lbTime.font = fontSize.fontName(name: .regular, size: sizeFour)
        lbAddress.font = fontSize.fontName(name: .regular, size: sizeFour)
        lbdeadLine.font = fontSize.fontName(name: .regular, size: sizeFour)
        lbDescription.font = fontSize.fontName(name: .regular, size: sizeSix)
        lbdeadLine.layer.cornerRadius = 12.5
        lbdeadLine.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
