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
    var imageFirst:UIImage?
    
    @IBOutlet weak var vViewAge: UIView!
    @IBOutlet weak var contraintAge: NSLayoutConstraint!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet var btRating: [UIButton]!
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
        imageFirst = Ionicons.star.image(32).maskWithColor(color: UIColor.colorWithRedValue(redValue: 255, greenValue: 255, blueValue: 255, alpha: 1))
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
        for i in btRating {
            i.setImage(imageFirst, for: .normal)
        }
        lbAge.font = UIFont(descriptor: UIFontDescriptor.preferredDescriptor(textStyle: UIFontTextStyle.footnote.rawValue), size: sizeFive)
        lbName.font = UIFont(descriptor: UIFontDescriptor.preferredDescriptor(textStyle: UIFontTextStyle.footnote.rawValue), size: sizeFive)
        lbPhone.font = UIFont(descriptor: UIFontDescriptor.preferredDescriptor(textStyle: UIFontTextStyle.footnote.rawValue), size: sizeFive)
        lbGender.font = UIFont(descriptor: UIFontDescriptor.preferredDescriptor(textStyle: UIFontTextStyle.footnote.rawValue), size: sizeFive)
        lbAddress.font = UIFont(descriptor: UIFontDescriptor.preferredDescriptor(textStyle: UIFontTextStyle.footnote.rawValue), size: sizeFive)
    }
  var isEnable : Bool?{
    didSet{
      btRating[0].isUserInteractionEnabled = isEnable!
      btRating[1].isUserInteractionEnabled = isEnable!
      btRating[2].isUserInteractionEnabled = isEnable!
      btRating[3].isUserInteractionEnabled = isEnable!
      btRating[4].isUserInteractionEnabled = isEnable!
    }
  }
  var point : Double? = 0{
    didSet{
      if point != nil{
        handle(point: point!)
      }
      
    }
  }
  var isHalf: Bool?{
    didSet{
      if isHalf == true{
        //self.setImage(Icon.by(name: .iosStarHalf, color: AppColor.homeButton1), for: .normal)
      }else{
        
      }
    }
  }
  
  func handle(point: Double){
    if point >= 5{
      btRating[0].isSelected = true
      btRating[1].isSelected = true
      btRating[2].isSelected = true
      btRating[3].isSelected = true
      btRating[4].isSelected = true
      return
    }
    btRating[0].isSelected = false
    btRating[1].isSelected = false
    btRating[2].isSelected = false
    btRating[3].isSelected = false
    btRating[4].isSelected = false
    
    var currentStart : Int = 0
    var currentPoint = point
    while currentPoint > 0 {
      if currentPoint < 0.3 {
        //btRating[currentStart].isHalf = true
      }else{
        if currentPoint < 0.7 {
         // btRating[currentStart].isHalf = true
        }
        else{
          btRating[currentStart].isSelected = true
        }
      }
      currentStart = currentStart + 1
      currentPoint = currentPoint - 1
    }
  }

    @IBAction func btRatingAction(_ sender: UIButton) {
//        let image = Ionicons.star.image(32).maskWithColor(color: UIColor(red: 253/255, green: 179/255, blue: 53/255, alpha: 1))
//        let tag = sender.tag
//        for i in btRating{
//            if i.tag <= tag {
//                i.setImage(image, for: .normal)
//            }else{
//                i.setImage(imageFirst, for: .normal)
//            }
//        }
    }
}
