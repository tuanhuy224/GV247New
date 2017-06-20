//
//  CommentCell.swift
//  GV24
//
//  Created by HuyNguyen on 5/31/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class CommentCell: CustomTableViewCell {

    @IBOutlet weak var topLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var createAtLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageAvatar.layer.cornerRadius = imageAvatar.frame.size.width/2
        imageAvatar.clipsToBounds = true
    }
    
}
