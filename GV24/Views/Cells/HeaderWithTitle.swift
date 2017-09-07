//
//  HeaderWithTitle.swift
//  GV24
//
//  Created by dinhphong on 8/30/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import UIKit
import IoniconsSwift

protocol SettingHeaderDelegate: class {
    func nearByWork(buttonSetting sender: UIButton)
}
class HeaderWithTitle: UICollectionReusableView {

    weak var delegate: SettingHeaderDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var title : String = ""{
        didSet{
            self.labelTitle.text = title
        }
    }
    
    private let labelTitle = UILabel()
   
    let buttonSetting : UIButton = {
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .clear
        btn.setImage(Icon.by(name: .gearB, size: 30).withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .lightGray
        btn.addTarget(self, action: #selector(handleSettingButton(_:)), for: .touchUpInside)
        return btn
    }()
    
    
    func setupView() {
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        addSubview(labelTitle)
        addSubview(buttonSetting)
        addConstraintWithFormat(format: "H:|-5-[v0]-45-|", views: labelTitle)
        labelTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        labelTitle.textColor = UIColor.gray
        labelTitle.numberOfLines = 0
        labelTitle.font = UIFont(name: "SFUIText-Light", size: 15)
        
        buttonSetting.topAnchor.constraint(equalTo: labelTitle.topAnchor, constant: 0).isActive = true
        buttonSetting.widthAnchor.constraint(equalToConstant: 30).isActive = true
        buttonSetting.heightAnchor.constraint(equalToConstant: 30).isActive = true
        buttonSetting.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
    }
    
    func handleSettingButton(_ sender: UIButton) {
        delegate?.nearByWork(buttonSetting: sender)
    }
}
