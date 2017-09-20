//
//  NotifiCell.swift
//  GV24
//
//  Created by HuyNguyen on 5/30/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import IoniconsSwift
@objc protocol changeLanguageDelegate:class {
   @objc optional func changeLanguage()
}
@objc protocol notificationDelegate:class {
    @objc optional func notificationAnnotation(noti:UISwitch)
}
class NotifiCell: CustomTableViewCell {
    @IBOutlet weak var btChoose: UIButton!
    @IBOutlet weak var btChooseLanguage: UIButton!
    @IBOutlet weak var lbNotif: UILabel!
    @IBOutlet weak var switchNoti: UISwitch!
    @IBOutlet weak var imgNotification: UIImageView!
    @IBOutlet weak var imgLanguage: UIImageView!
    weak var delegate:changeLanguageDelegate?
    weak var notiDelegate:notificationDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        let image = Ionicons.chevronRight.image(32).maskWithColor(color: AppColor.backButton)
        imgNotification.image = Ionicons.androidNotifications.image(32).maskWithColor(color: AppColor.backButton)
        imgLanguage.image = Ionicons.iosWorld.image(32).maskWithColor(color: AppColor.backButton)
        btChoose.setImage(image, for: .normal)
        lbNotif.font = fontSize.fontName(name: .regular, size: sizeFive)
        btChoose.titleLabel?.font = fontSize.fontName(name: .regular, size: sizeFive)
        cornerImage(imgNotification, 4)
        cornerImage(imgLanguage, 4)
    }
    
    func cornerImage(_ img: UIImageView, _ radius: CGFloat) {
        img.layer.cornerRadius = radius
        img.clipsToBounds = true
    }

    @IBAction func notifiAction(_ sender: Any) {
        if notiDelegate != nil {
            notiDelegate?.notificationAnnotation!(noti: switchNoti)
        }
    }
    @IBAction func btChooseLanguageAction(_ sender: Any) {
        if delegate != nil {
            delegate?.changeLanguage!()
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
