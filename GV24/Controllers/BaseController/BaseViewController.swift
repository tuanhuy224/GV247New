//
//  BaseViewController.swift
//  GV24
//
//  Created by admin on 5/24/17.
//  Copyright © 2017 admin. All rights reserved.
//
import UIKit

class BaseViewController: UIViewController {
    let install = NetworkStatus.sharedInstance
    var islog = false
    var viewNetwork:UIView?
    var lbViewNetwork:UILabel?
    let backItem = UIBarButtonItem()
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
        self.setupViewBase()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back".localize, style: UIBarButtonItemStyle.done, target: nil, action: nil)
        install.startNetworkReachabilityObserver()
        if install.reachabilityManager?.isReachable == false {
            self.displayNetwork()
        }
        print("++++view display:\(self)+++++++")
    }
    func setupViewBase() {}
    func decorate(){}
    func displayNetwork(){
        viewNetwork = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        lbViewNetwork = UILabel(frame: CGRect(x: self.view.center.x, y: 0, width: self.view.frame.size.width, height: 20))
        lbViewNetwork?.backgroundColor = UIColor.red
        viewNetwork?.addSubview(lbViewNetwork!)
    }
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
