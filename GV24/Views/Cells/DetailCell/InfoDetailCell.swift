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
        lbTools.font = fontSize.fontName(name: .regular, size: sizeFive)
        lbTools.textColor = AppColor.backButton
        imageAvatar.layer.cornerRadius = imageAvatar.frame.size.width/2
        imageAvatar.clipsToBounds = true
        imageMoney.backgroundColor = UIColor.clear
        imageDate.backgroundColor = UIColor.clear
        imageMoney.image = Ionicons.socialUsd.image(32).imageWithColor(color: AppColor.backButton)
        imageDate.image = Ionicons.androidAlarmClock.image(32).imageWithColor(color: AppColor.backButton)
        imageAddress.image = Ionicons.home.image(32).imageWithColor(color: AppColor.backButton)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
    
    var work: Work? {
        didSet{
            guard let endAt = work?.workTime?.endAt else {return}
            if Date(isoDateString: endAt).comparse == true {
                lbdeadLine.isHidden = false
                lbdeadLine.text = "Expired".localize
            }else{
                lbdeadLine.isHidden = true
            }
            
            
            var deadlineWitdh:CGFloat = 0
            
            
            if lbdeadLine.isHidden{
                lbdeadLine.isHidden = true
                
            }else{
                let text = lbdeadLine.text ?? ""
                let height = lbdeadLine.bounds.height
                let font = lbdeadLine.font!
                deadlineWitdh = text.width(withConstraintedHeight: height, font: font)
                deadlineWitdh = ceil(deadlineWitdh) + 20
            }
            contraintWidthDeadline.constant = deadlineWitdh
            lbDescription.text = "Description".localize
            lbTitle.text = work?.info?.title
            lbSubTitle.text = work?.info?.workName?.name
            lbComment.text = work?.info?.content
            guard let start = work?.workTime?.startAt else {return}
            guard let end = work?.workTime?.endAt else {return}
            lbDate.text = "\(Date(isoDateString: start).dayMonthYear)"
            lbTime.text = Date(isoDateString: start).hourMinute + " - " + Date(isoDateString: end).hourMinute
            lbAddress.text = work?.stakeholders?.owner?.address?.name
            let tool = work?.info?.tools
            if  tool == true {
                lbTools.isHidden = false
                lbTools.text = "Bringyourcleaningsupplies".localize
            }
            let salary = work?.info?.salary
            if salary == 0 {
                lbMoney.text = "Timework".localize
            }else{
                
                lbMoney.text = String().numberFormat(number: salary ?? 0) + " " + "VND"
            }
        }
    }
}
