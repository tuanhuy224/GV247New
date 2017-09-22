//
//  InforCell.swift
//  GV24
//
//  Created by HuyNguyen on 5/31/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import IoniconsSwift

class InforCell: CustomTableViewCell {
    var buttons:[UIButton]?
    
    
    @IBOutlet weak var bottomAge: NSLayoutConstraint!
    @IBOutlet weak var topHeightAge: NSLayoutConstraint!
    @IBOutlet weak var vViewAge: UIView!
    @IBOutlet weak var contraintAge: NSLayoutConstraint!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet var btRating: [UIButton]?{
        didSet{
            getStar()
        }
    }
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var imageAddress: UIButton!
    @IBOutlet weak var imagePhone: UIButton!
    @IBOutlet weak var ImageGender: UIButton!
    @IBOutlet weak var imageAge: UIButton!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var lbPhone: UILabel!
    @IBOutlet weak var lbAge: UILabel!
    @IBOutlet weak var lbGender: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatar.layer.cornerRadius = avatar.frame.size.width/2
        avatar.clipsToBounds = true
        avatar.layer.borderWidth = 1
        avatar.layer.borderColor = UIColor.white.cgColor
        lbName.textColor = UIColor.white
        DispatchQueue.main.async {
            self.avatar.image = UIImage(named: "avatar")
        }
        let imagegender = Ionicons.transgender.image(32)
        ImageGender.setImage(imagegender, for: .normal)
        ImageGender.tintColor = AppColor.backButton
        let imagephone = Ionicons.androidPhonePortrait.image(32)
        imagePhone.setImage(imagephone, for: .normal)
        imagePhone.tintColor = AppColor.backButton
        let imageage = Ionicons.androidCalendar.image(32)
        imageAge.setImage(imageage, for: .normal)
        imageAge.tintColor = AppColor.backButton
        let imageaddress = Ionicons.iosHome.image(32)
        imageAddress.setImage(imageaddress, for: .normal)
        imageAddress.tintColor = AppColor.backButton
        lbAge.font = fontSize.fontName(name: .regular, size: sizeFive)
        lbName.font = fontSize.fontName(name: .regular, size: sizeFive)
        lbPhone.font = fontSize.fontName(name: .regular, size: sizeFive)
        lbGender.font = fontSize.fontName(name: .regular, size: sizeFive)
        lbAddress.font = fontSize.fontName(name: .regular, size: sizeFive)
    }
    func getStar() {
        let image = Ionicons.star.image(32).maskWithColor(color: AppColor.start)
        guard let tag = UserDefaultHelper.currentUser?.workInfor?.evaluation_point else{return}
        for i in btRating!{
            if i.tag <= tag {
                i.setImage(image, for: .normal)
            }else{
                i.setImage(imageFirst, for: .normal)
            }
        }
    }
    
    
    var workPending: Work? {
        didSet{
            guard let gender = workPending?.stakeholders?.owner?.gender! else{return}
            if gender == 0 {
                lbGender.text = "Boy".localize
            }else{
                lbGender.text = "Girl".localize
            }
            lbAddress.text = workPending?.stakeholders?.owner?.address?.name
            lbPhone.text = workPending?.stakeholders?.owner?.phone
            let url = URL(string: (workPending?.stakeholders?.owner?.image)!)
            if url == nil {
                imageProfile.image = UIImage(named: "avatar")
                avatar.image = UIImage(named: "avatar")
            }else{
                DispatchQueue.main.async {
                    self.avatar.kf.setImage(with: url)
                    self.imageProfile.kf.setImage(with: url)
                }
            }
            lbName.text = workPending?.stakeholders?.owner?.name
            lbAge.isHidden = true
            vViewAge.isHidden = true
            contraintAge.constant = 0
            imageAge.isHidden = true
        }
    }
    
    @IBAction func btRatingAction(_ sender: UIButton) {
        
    }
}
