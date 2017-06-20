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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    func setupCell() {
        arrowForward.image = Ionicons.iosArrowForward.image(18, color: UIColor.lightGray)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
