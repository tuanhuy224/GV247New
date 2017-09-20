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
    
    let icon = Ionicons.androidAlarmClock.image(32).imageWithColor(color: AppColor.backButton)
    @IBOutlet weak var contraintWidthDeadline: NSLayoutConstraint!
    @IBOutlet weak var constraintWidthDirect: NSLayoutConstraint!
    @IBOutlet weak var lbDirect: UILabel!
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

            btImage.setImage(icon, for: .normal)
        }
    }
    @IBOutlet weak var imageWork: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    func setupCell() {
        UILabel.cornerLable(lb: lbDirect, radius: 12.5)
        UILabel.cornerLable(lb: lbDeadline, radius: 12.5)
        
        UIImageView.cornerImage(img: imageWork, radius: imageWork.bounds.size.width/2)
        workNameLabel.font = fontSize.fontName(name: .medium, size: sizeEight)
        lbDeadline.font = fontSize.fontName(name: .regular, size: sizeFour)
        lbDist.font = fontSize.fontName(name: .regular, size: sizeFour)
        timeWork.font = fontSize.fontName(name: .regular, size: sizeFour)
        lbTimePost.font = fontSize.fontName(name: .regular, size: sizeFour)
        lbDirect.font = fontSize.fontName(name: .regular, size: sizeFour)
        createdDate.font = fontSize.fontName(name: .regular, size: sizeFive)
        //workNameLabel.font = UIFont(descriptor: UIFontDescriptor.MediumDescriptor(textStyle: UIFontTextStyle.caption2.rawValue), size: sizeEight)
//        lbDeadline.font = UIFont(descriptor: UIFontDescriptor.RegularDescriptor(textStyle: UIFontTextStyle.footnote.rawValue), size: sizeFour)
//        lbDist.font = UIFont(descriptor: UIFontDescriptor.RegularDescriptor(textStyle: UIFontTextStyle.footnote.rawValue), size: sizeFour)
//        timeWork.font = UIFont(descriptor: UIFontDescriptor.RegularDescriptor(textStyle: UIFontTextStyle.footnote.rawValue), size: sizeFour)
//        lbTimePost.font = UIFont(descriptor: UIFontDescriptor.RegularDescriptor(textStyle: UIFontTextStyle.footnote.rawValue), size: sizeFour)
//        lbDeadline.font = UIFont(descriptor: UIFontDescriptor.RegularDescriptor(textStyle: UIFontTextStyle.footnote.rawValue), size: sizeFour)
//        lbDirect.font = UIFont(descriptor: UIFontDescriptor.RegularDescriptor(textStyle: UIFontTextStyle.footnote.rawValue), size: sizeFour)
//        createdDate.font = UIFont(descriptor: UIFontDescriptor.RegularDescriptor(textStyle: UIFontTextStyle.footnote.rawValue), size: sizeFive)

    }

    override func layoutSubviews() {
        super.layoutSubviews()

    }
}
