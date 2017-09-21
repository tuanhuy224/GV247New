//
//  HistoryViewCell.swift
//  GV24
//
//  Created by HuyNguyen on 5/29/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import IoniconsSwift



class DirectCell: CustomTableViewCell {
    
    let icon = Ionicons.androidAlarmClock.image(32).imageWithColor(color: AppColor.backButton)
    @IBOutlet weak var constraintWidthDirect: NSLayoutConstraint!
    @IBOutlet weak var lbDirect: UILabel!
    @IBOutlet weak var lbTimePost: UILabel!
    @IBOutlet weak var lbDist: UILabel!
    @IBOutlet weak var btImage: UIButton!
    @IBOutlet weak var timeWork: UILabel!
    @IBOutlet weak var createdDate: UILabel!
    @IBOutlet weak var workNameLabel: UILabel!
    @IBOutlet weak var iconAlarm: UIImageView!{
        didSet{
            
            btImage.setImage(icon, for: .normal)
        }
    }
    @IBOutlet weak var imageWork: UIImageView!
    
    
    
    var proccessPending: Work? {
        didSet{

            lbDirect.text = "Direct".localize
            
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
        
        UIImageView.cornerImage(img: imageWork, radius: imageWork.bounds.size.width/2)
        workNameLabel.font = fontSize.fontName(name: .medium, size: sizeEight)
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
