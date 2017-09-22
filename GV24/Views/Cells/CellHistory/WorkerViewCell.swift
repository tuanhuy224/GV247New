//
//  WorkerViewCell.swift
//  GV24
//
//  Created by admin on 6/6/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import IoniconsSwift

class WorkerViewCell: CustomTableViewCell {

    @IBOutlet weak var arrowForward: UIImageView!
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var workCompletedLabel: UILabel!
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var separateLine: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    var work: Work? {
        didSet{
            guard let image = work?.stakeholders?.owner?.image else {return}
            let url = URL(string: image)
            if url == nil {
                imageUser.image = UIImage(named: "avatar")
            }else{
                imageUser.kf.setImage(with:url)
                
            }
            imageUser.layer.cornerRadius = imageUser.frame.width / 2
            imageUser.clipsToBounds = true
            nameLabel.text = work?.stakeholders?.owner?.name!
            addressLabel.text = work?.stakeholders?.owner?.address?.name!
            workCompletedLabel.text = "CompletedWork".localize
        }
    }
    
    func setupCell() {
        arrowForward.image = Ionicons.iosArrowForward.image(18, color: UIColor.lightGray)
        nameLabel.font = UIFont(descriptor: UIFontDescriptor.MediumDescriptor(textStyle: UIFontTextStyle.headline.rawValue), size: sizeSeven)
        addressLabel.font = UIFont(descriptor: UIFontDescriptor.RegularDescriptor(textStyle: UIFontTextStyle.footnote.rawValue), size: sizeFour)
        nameLabel.font = UIFont(descriptor: UIFontDescriptor.MediumDescriptor(textStyle: UIFontTextStyle.subheadline.rawValue), size: sizeEight)
        addressLabel.font = UIFont(descriptor: UIFontDescriptor.RegularDescriptor(textStyle: UIFontTextStyle.footnote.rawValue), size: sizeThree)
        workCompletedLabel.font = UIFont(descriptor: UIFontDescriptor.preferredDescriptor(textStyle: UIFontTextStyle.footnote.rawValue), size: sizeEight)
        commentLabel.font = UIFont(descriptor: UIFontDescriptor.preferredDescriptor(textStyle: UIFontTextStyle.body.rawValue), size: sizeFour)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
