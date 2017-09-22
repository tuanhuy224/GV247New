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
    
    
    
    var proccessPending: Work? {
        didSet{
            
            if proccessPending?.process?.id == WorkStatus.Direct.rawValue  && Date(isoDateString: (proccessPending?.workTime?.endAt)!).comparse == true {
                lbDirect.isHidden = true
                lbDeadline.isHidden = false
                lbDeadline.text = "Expired".localize
            }else if Date(isoDateString: (proccessPending?.workTime?.endAt)!).comparse == true{
                lbDirect.isHidden = true
                lbDeadline.isHidden = false
                lbDeadline.text = "Expired".localize
                
            }else if proccessPending?.process?.id == WorkStatus.OnCreate.rawValue {
                lbDirect.isHidden = true
                lbDeadline.isHidden = true
                constraintWidthDirect.constant = 0
                contraintWidthDeadline.constant = 0
  
            }else{
                lbDirect.isHidden = false
                lbDeadline.isHidden = true
                lbDirect.text = "Direct".localize
            }
            guard let image = proccessPending?.info?.workName?.image else {return}
            let url = URL(string: image)
            if url == nil {
                imageWork.image = UIImage(named: "avatar")
            }else{
                DispatchQueue.main.async {
                    self.imageWork.kf.setImage(with:url)
                }
            }
            workNameLabel.text = self.proccessPending?.info?.title
            createdDate.text = "\(Date(isoDateString: (proccessPending?.workTime?.startAt)!).dayMonthYear)"
            lbDist.text = "Proccess".localize
            lbTimePost.text = "\(Date().dateComPonent(datePost: (proccessPending?.history?.createAt)!))"
            UserDefaultHelper.setUserOwner(user: proccessPending?.stakeholders?.owner)
            timeWork.text = Date(isoDateString: (proccessPending?.workTime?.startAt)!).hourMinute + " - " + Date(isoDateString: (proccessPending?.workTime?.endAt)!).hourMinute
        }
    }
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
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
