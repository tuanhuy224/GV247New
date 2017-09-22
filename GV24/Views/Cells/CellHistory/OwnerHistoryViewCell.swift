//
//  OwnerTableViewCell.swift
//  GV24
//
//  Created by admin on 6/5/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import IoniconsSwift
protocol getOwnerId {
    func getOwnerId(cell:OwnerHistoryViewCell,index:Any)
}
class OwnerHistoryViewCell: CustomTableViewCell {
    var delegate:getOwnerId?
    var buttons:[UIButton]?
    @IBOutlet var btnRating: [UIButton]!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var arrowForward: UIImageView!
    @IBOutlet weak var workListButton: UIButton!
    
    var unstar: UIImage = {
        let img = Ionicons.iosStarOutline.image(32).maskWithColor(color: AppColor.unStart)
        return img!
    }()
    var star: UIImage = {
        let img = Ionicons.star.image(18).maskWithColor(color: AppColor.start)
        return img!
    }()
    
    var owner: Owner? {
        didSet{
            userName.text = owner?.name
            guard let time = owner?.workTime.last else {return}
            dateLabel.text = Date(isoDateString: time).dayMonthYear
            workListButton.setTitle("WorkList".localize, for: .normal)
            guard let image = owner?.image else {return}
            let url = URL(string: image)
            userImage.kf.setImage(with: url, placeholder: UIImage(named: "avatar"), options: nil, progressBlock: nil, completionHandler: nil)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    func setupCell() {
        userImage.layer.cornerRadius = userImage.frame.size.width/2
        userImage.clipsToBounds = true
        let arrowForwardImage = Ionicons.iosArrowForward.image(12)
        arrowForward.image = arrowForwardImage
        for i in btnRating {
            i.setImage(self.star, for: .normal)
        }
        userName.font = fontSize.fontName(name: .medium, size: sizeSeven)
        dateLabel.font = fontSize.fontName(name: .regular, size: sizeFour)
    }
    
    @IBAction func chooseId(_ sender: Any) {
        self.delegate?.getOwnerId(cell: self, index: sender)
    }
    @IBAction func btnRatingAction(_ sender: UIButton) {
        let tag = sender.tag
        for i in btnRating {
            if i.tag <= tag {
                i.setImage(star, for: .normal)
            }
            else {
                i.setImage(unstar, for: .normal)
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
