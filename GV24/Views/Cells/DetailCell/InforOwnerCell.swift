//
//  InforOwnerCell.swift
//  GV24
//
//  Created by HuyNguyen on 6/14/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class InforOwnerCell: CustomTableViewCell {
    @IBOutlet weak var lbComment: UILabel!
    @IBOutlet weak var btReport: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        btReport.setTitleColor(UIColor.colorWithRedValue(redValue: 47, greenValue: 186, blueValue: 194, alpha: 1), for: .normal)
        lbComment.font = UIFont(descriptor: UIFontDescriptor.preferredDescriptor(textStyle: UIFontTextStyle.footnote.rawValue), size: sizeFour)
    }
}
