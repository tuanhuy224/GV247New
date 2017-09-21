//
//  CancelCell.swift
//  GV24
//
//  Created by HuyNguyen on 6/14/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import IoniconsSwift

@objc protocol denyRequestDelegate:class{
    @objc optional func denyRequest()
}
@objc protocol CancelWorkDelegate:class{
    @objc optional func CancelButton()
    @objc optional func CancelButtonForPending()
}
class CancelCell: CustomTableViewCell {
    @IBOutlet weak var btCancel: UIButton!
    @IBOutlet weak var lbCancelDetail: UILabel!
    @IBOutlet weak var viewCancelBottom: UIView!
    @IBOutlet weak var lbCancel: UILabel!
    @IBOutlet weak var viewSpace: UIView!
    weak var delegate:CancelWorkDelegate?
    weak var denyDelegate:denyRequestDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()

        btCancel.backgroundColor = AppColor.buttonDelete
        UIButton.cornerButton(bt: btCancel, radius: 8)
        lbCancel.textColor = AppColor.white
        lbCancel.font = fontSize.fontName(name: .regular, size: sizeSix)
    } 
    @IBAction func btDeleteWork(_ sender: Any) {
        if delegate != nil {
            delegate?.CancelButton!()
        }
        if denyDelegate != nil {
            denyDelegate?.denyRequest!()
        }
    }

}
