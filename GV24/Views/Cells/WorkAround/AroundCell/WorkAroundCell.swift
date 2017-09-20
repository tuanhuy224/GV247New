//
//  WorkAroundCell.swift
//  GV24
//
//  Created by dinhphong on 8/28/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class WorkAroundCell: UICollectionViewCell {
    
    var work: Work? {
        didSet{
            iconType.kf.setImage(with: URL(string: (work?.info?.workName?.image)!), placeholder: UIImage(named: "nau an"), options: nil, progressBlock: nil, completionHandler: nil)
            labelTitle.text = work?.info?.title
            guard let dist = work?.dist?.calculated else {return}
            labelLocation.text = cal(cal: floor(dist))
            let date = Date(isoDateString: (work?.info?.time?.startAt)!)
            labelDate.text = date.dayMonthYear
            labelUploadAt.text = Date().dateComPonent(datePost: (work?.history!.createAt!)!)
            labelTimes.text = Date(isoDateString: (work?.info?.time?.startAt)!).hourMinute + " - " + Date(isoDateString: (work?.info?.time?.endAt)!).hourMinute
        }
    }
    
    func cal(cal:Double) -> String {
        if cal > 1000 {
            return "\(floor(cal/1000)) km"
        }else{
            return "\(cal) m"
        }
    }
    
    let margin : CGFloat = 10
    
    var marginTitle: CGFloat?{
        didSet{
            labelTitle.rightAnchor.constraint(equalTo: rightAnchor, constant: -marginTitle!).isActive = true
        }
    }
    
    let iconType : IconView = {
        let iv = IconView(image: "nau an", size: 50)
        return iv
    }()
    
    
    let iconAlarmClock : IconView = {
        let iv = IconView(icon: .androidAlarmClock, size: 20, color: AppColor.backButton)
        return iv
    }()
    
    let labelTitle : UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.numberOfLines = 1
        lb.font = UIFont(name: "SFUIText-Medium", size: 14)!
        lb.text = "Lau dọn nhà"
        return lb
    }()
    
    let labelLocation : UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "SFUIText-Light", size: 12)!
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "77 m"
        lb.textColor = .gray
        return lb
    }()
    
    let labelUploadAt : UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "SFUIText-Light", size: 12)!
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "23 phút trước"
        lb.textAlignment = .center
        lb.textColor = .gray
        return lb
    }()
    
    
    let labelDate : UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "SFUIText-Light", size: 16)!
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "10/10/2017"
        return lb
    }()
    
    
    let labelTimes : UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "SFUIText-Light", size: 13)!
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "9h00 am - 12h00 am"
        lb.textColor = .gray
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView() {
        backgroundColor = UIColor.white
        let verticalLine = UIView.verticalLine(height : 10)
        addSubview(iconType)
        addSubview(iconAlarmClock)
        addSubview(labelTitle)
        addSubview(labelLocation)
        addSubview(labelDate)
        addSubview(labelTimes)
        addSubview(labelUploadAt)
        addSubview(verticalLine)
        
        iconType.topAnchor.constraint(equalTo: topAnchor, constant: margin/2).isActive = true
        iconType.leftAnchor.constraint(equalTo: leftAnchor, constant: margin).isActive = true
        
        iconAlarmClock.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margin).isActive = true
        iconAlarmClock.centerXAnchor.constraint(equalTo: iconType.centerXAnchor, constant: 0).isActive = true
        
        labelTitle.topAnchor.constraint(equalTo: iconType.topAnchor, constant: margin/4).isActive = true
        labelTitle.leftAnchor.constraint(equalTo: iconType.rightAnchor, constant: margin).isActive = true
        labelTitle.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -margin).isActive = true
        
        
        labelLocation.leftAnchor.constraint(equalTo: iconType.rightAnchor, constant: margin).isActive = true
        labelLocation.bottomAnchor.constraint(equalTo: iconType.bottomAnchor, constant: -margin/4).isActive = true
        addConstraint(NSLayoutConstraint(item: labelLocation, attribute: .width, relatedBy: .equal, toItem: labelUploadAt, attribute: .width, multiplier: 1, constant: 0))
        
        addConstraintWithFormat(format: "H:[v0][v1][v2]|", views: labelLocation, verticalLine, labelUploadAt)
        
        verticalLine.centerYAnchor.constraint(equalTo: labelLocation.centerYAnchor, constant: 0).isActive = true
        
        labelUploadAt.centerYAnchor.constraint(equalTo: labelLocation.centerYAnchor, constant: 0).isActive = true
        
        labelDate.centerYAnchor.constraint(equalTo: iconAlarmClock.centerYAnchor, constant: 0).isActive = true
        labelDate.leftAnchor.constraint(equalTo: iconType.rightAnchor, constant: margin).isActive = true
        labelDate.rightAnchor.constraint(equalTo: verticalLine.leftAnchor, constant: 0).isActive = true
        
        labelTimes.centerYAnchor.constraint(equalTo: iconAlarmClock.centerYAnchor, constant: 0).isActive = true
        labelTimes.leftAnchor.constraint(equalTo: verticalLine.rightAnchor, constant: 0).isActive = true
        labelTimes.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
    }
    
}
