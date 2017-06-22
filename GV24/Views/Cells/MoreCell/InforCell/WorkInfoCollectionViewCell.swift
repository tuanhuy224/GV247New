//
//  WorkInfoCollectionViewCell.swift
//  GV24
//
//  Created by Macbook Solution on 6/19/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
protocol disSelectIndexPathDelegate:class {
    func didSelect(index:Any)
}
class WorkInfoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var btTap: UIButton!
    weak var delegate:disSelectIndexPathDelegate?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    @IBAction func btAction(_ sender: Any) {
        if delegate != nil {
            self.delegate?.didSelect(index: sender)
        }
    }
}
