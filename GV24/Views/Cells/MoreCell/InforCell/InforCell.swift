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
    ImageGender.tintColor = UIColor.colorWithRedValue(redValue: 47, greenValue: 186, blueValue: 194, alpha: 1)
    let imagephone = Ionicons.androidPhonePortrait.image(32)
    imagePhone.setImage(imagephone, for: .normal)
    imagePhone.tintColor = UIColor.colorWithRedValue(redValue: 47, greenValue: 186, blueValue: 194, alpha: 1)
    let imageage = Ionicons.androidCalendar.image(32)
    imageAge.setImage(imageage, for: .normal)
    imageAge.tintColor = UIColor.colorWithRedValue(redValue: 47, greenValue: 186, blueValue: 194, alpha: 1)
    let imageaddress = Ionicons.iosHome.image(32)
    imageAddress.setImage(imageaddress, for: .normal)
    imageAddress.tintColor = UIColor.colorWithRedValue(redValue: 47, greenValue: 186, blueValue: 194, alpha: 1)
    lbAge.font = fontSize.fontName(name: .regular, size: sizeFive)
    lbName.font = fontSize.fontName(name: .regular, size: sizeFive)
    lbPhone.font = fontSize.fontName(name: .regular, size: sizeFive)
    lbGender.font = fontSize.fontName(name: .regular, size: sizeFive)
    lbAddress.font = fontSize.fontName(name: .regular, size: sizeFive)
  }
  func getStar() {
    let image = Ionicons.star.image(32).maskWithColor(color: UIColor(red: 253/255, green: 179/255, blue: 53/255, alpha: 1))
    let tag = UserDefaultHelper.currentUser?.workInfor?.evaluation_point
    for i in btRating!{
      if i.tag <= tag! {
        i.setImage(image, for: .normal)
      }else{
        i.setImage(imageFirst, for: .normal)
      }
    }
  }
  
  @IBAction func btRatingAction(_ sender: UIButton) {
    
  }
}
