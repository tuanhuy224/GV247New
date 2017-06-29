//
//  FinishedWorkCell.swift
//  GV24
//
//  Created by admin on 6/6/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import IoniconsSwift

class FinishedWorkCell: CustomTableViewCell {
    @IBOutlet weak var btPay: UIButton!
    @IBOutlet weak var salaryImage: UIImageView!
    @IBOutlet weak var dateImage: UIImageView!
    @IBOutlet weak var addressImage: UIImageView!
    @IBOutlet weak var workImage: UIImageView!
    @IBOutlet weak var workNameLabel: UILabel!
    @IBOutlet weak var workTypeLabel: UILabel!
    @IBOutlet weak var workContentLabel: UILabel!
    @IBOutlet weak var workSalaryLabel: UILabel!
    @IBOutlet weak var workCreateAtLabel: UILabel!
    @IBOutlet weak var workAddressLabel: UILabel!
    @IBOutlet weak var workTimeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }

    func setupCell() {
        btPay.setTitle("Thanhtoan", for: .normal)
        btPay.tintColor = UIColor.colorWithRedValue(redValue: 46, greenValue: 188, blueValue: 194, alpha: 1)
        btPay.isHidden = true
        salaryImage.image = Ionicons.socialUsd.image(15, color: UIColor.colorWithRedValue(redValue: 46, greenValue: 188, blueValue: 194, alpha: 1))
        addressImage.image = Ionicons.home.image(15, color: UIColor.colorWithRedValue(redValue: 46, greenValue: 188, blueValue: 194, alpha: 1))
        dateImage.image = Ionicons.androidAlarmClock.image(32, color: UIColor.colorWithRedValue(redValue: 46, greenValue: 188, blueValue: 194, alpha: 1))
        workNameLabel.font = UIFont(descriptor: UIFontDescriptor.MediumDescriptor(textStyle: UIFontTextStyle.subheadline.rawValue), size: sizeEight)
        workTypeLabel.font = UIFont(descriptor: UIFontDescriptor.RegularDescriptor(textStyle: UIFontTextStyle.footnote.rawValue), size: sizeThree)
        workContentLabel.font = UIFont(descriptor: UIFontDescriptor.preferredDescriptor(textStyle: UIFontTextStyle.body.rawValue), size: sizeFour)
        workSalaryLabel.font = UIFont(descriptor: UIFontDescriptor.preferredDescriptor(textStyle: UIFontTextStyle.body.rawValue), size: sizeFive)
        workCreateAtLabel.font = UIFont(descriptor: UIFontDescriptor.preferredDescriptor(textStyle: UIFontTextStyle.body.rawValue), size: sizeFive)
        workAddressLabel.font = UIFont(descriptor: UIFontDescriptor.preferredDescriptor(textStyle: UIFontTextStyle.body.rawValue), size: sizeFive)
        workTimeLabel.font = UIFont(descriptor: UIFontDescriptor.preferredDescriptor(textStyle: UIFontTextStyle.footnote.rawValue), size: sizeFive)
    }    
}
