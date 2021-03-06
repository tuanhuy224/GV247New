//
//  LoadingView.swift
//  GV24
//
//  Created by DuongNguyen on 7/3/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import UIKit

class LoadingView: NSObject {
    let blackView = UIView()
    let mainView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.widthAnchor.constraint(equalToConstant: 50).isActive = true
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    lazy var activity : UIActivityIndicatorView = {
        let act = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        act.hidesWhenStopped = true
        act.translatesAutoresizingMaskIntoConstraints = false
        act.startAnimating()
        return act
    }()
    override init() {
        super.init()
    }
    
    func setupMainView(){
        if let window = UIApplication.shared.keyWindow{
            self.blackView.isHidden = true
            self.mainView.isHidden = true
            
            blackView.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
            window.addSubview(blackView)
            window.addSubview(mainView)
            mainView.addSubview(activity)
            
            blackView.frame = window.frame
            blackView.alpha = 0
            mainView.centerYAnchor.constraint(equalTo: blackView.centerYAnchor, constant: 0).isActive = true
            mainView.centerXAnchor.constraint(equalTo: blackView.centerXAnchor, constant: 0).isActive = true
            
            activity.centerXAnchor.constraint(equalTo: mainView.centerXAnchor, constant: 0).isActive = true
            activity.centerYAnchor.constraint(equalTo: mainView.centerYAnchor, constant: 0).isActive = true
        }
    }
    
    func show(){
        setupMainView()
        self.blackView.isHidden = false
        self.mainView.isHidden = false
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 1
            self.mainView.alpha = 1
        }, completion: nil)
    }
    
    func close(){
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0
            self.mainView.alpha = 0

        }) { (Bool) in
            self.blackView.isHidden = true
            self.mainView.isHidden = true
        }
    }
}
