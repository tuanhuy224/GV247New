//
//  WorkTableViewCell.swift
//  GV24
//
//  Created by HuyNguyen on 5/25/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import IoniconsSwift
import Alamofire
protocol sendIdForViewDetailDelegate:class {
    func sendId(id:String)
}
class WorkTableViewCell: UITableViewCell {
    weak var delegate:sendIdForViewDetailDelegate?
    @IBOutlet weak var amountWork: UILabel!
    @IBOutlet weak var lbWork: UILabel!
    @IBOutlet weak var imageWork: UIImageView!
    @IBOutlet weak var iconRight: UIButton!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let icon = Ionicons.chevronRight.image(12)
        iconRight.setImage(icon, for: .normal)
        iconRight.tintColor = UIColor(red: 24/255, green: 179/255, blue: 110/255, alpha: 1)
        customImage()
    }
    
    
       func customImage() {
        imageWork.layer.cornerRadius = imageWork.frame.size.width/2
        imageWork.clipsToBounds = true
    }
    func renderData(user:User) {
       
        self.amountWork.text = user.name
        Alamofire.download("\(user)").responseData { response in
            if let data = response.result.value {
                let image = UIImage(data: data)
                self.imageWork.image = image
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

