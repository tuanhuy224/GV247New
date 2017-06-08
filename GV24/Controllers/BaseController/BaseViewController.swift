//
//  BaseViewController.swift
//  GV24
//
//  Created by admin on 5/24/17.
//  Copyright © 2017 admin. All rights reserved.
//
import UIKit

class BaseViewController: UIViewController {
    var islog = false
    var actionSheet: UIAlertController!
    var dGlocale = DGLocalization()
    override func viewDidLoad() {
        super.viewDidLoad()
        DGLocalization.sharedInstance.Delegate = self
        self.decorate()
        print("====Current self:\(self)====")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("++++view display:\(self)+++++++")
        self.setupViewBase()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func setupViewBase() {
    
    }
    func decorate(){}
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
}

extension BaseViewController:DGLocalizationDelegate{
    func languageDidChanged(to: (String)) {
        print("language changed to \(to)")
    }
}
