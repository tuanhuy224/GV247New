//
//  FinishedWorkCell.swift
//  GV24
//
//  Created by admin on 6/6/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import IoniconsSwift

class FinishedWorkCell: UITableViewCell {

    @IBOutlet weak var salaryImage: UIImageView!
    @IBOutlet weak var dateImage: UIImageView!
    @IBOutlet weak var addressImage: UIImageView!
    
    //Outlets UI to set data
    @IBOutlet weak var workImage: UIImageView!
    @IBOutlet weak var workNameLabel: UILabel!
    @IBOutlet weak var workTypeLabel: UILabel!
    @IBOutlet weak var workContentLabel: UILabel!
    @IBOutlet weak var workSalaryLabel: UILabel!
    @IBOutlet weak var workCreateAtLabel: UILabel!
    @IBOutlet weak var workAddressLabel: UILabel!
    @IBOutlet weak var workTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        salaryImage.image = Ionicons.socialUsd.image(15, color: UIColor.colorWithRedValue(redValue: 46, greenValue: 188, blueValue: 194, alpha: 1))
        addressImage.image = Ionicons.home.image(15, color: UIColor.colorWithRedValue(redValue: 46, greenValue: 188, blueValue: 194, alpha: 1))
        dateImage.image = Ionicons.iosAlarmOutline.image(15, color: UIColor.colorWithRedValue(redValue: 46, greenValue: 188, blueValue: 194, alpha: 1))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
