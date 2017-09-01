//
//  FilterControllCell.swift
//  GV24
//
//  Created by dinhphong on 8/30/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import UIKit


class FilterControllCell : UITableViewCell {
    
    
    var title: String = "Vị trí" {
        didSet{
            labelTitle.text = title
        }
    }
    
    var status: String = "Hiện tại" {
        didSet{
            labelStatus.text = status
        }
    }
    
    private let labelTitle: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont(name: "SFUIText-Light", size: 15)
        lb.textColor = .lightGray
        return lb
    }()
    
    private let labelStatus: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont(name: "SFUIText-Light", size: 13)
        lb.textColor = .lightGray
        return lb
    }()

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        self.selectionStyle = .none
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.addSubview(labelTitle)
        self.addSubview(labelStatus)
        
        labelTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        labelTitle.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true

        labelStatus.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        labelStatus.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
    }
}
