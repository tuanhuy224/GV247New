//
//  HomeView.swift
//  GV24
//
//  Created by admin on 5/24/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import IoniconsSwift
import Alamofire
import SwiftyJSON
import FirebaseCore
import FirebaseInstanceID

class HomeViewDisplayController: BaseViewController {
    var user:User?
    @IBOutlet weak var lbHistory: UILabel!
    @IBOutlet weak var lbManage: UILabel!
    @IBOutlet weak var workAround: UIButton!
    @IBOutlet weak var manageButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var viewDisplay: UIView!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var lbLogo: UILabel!
    var titleAround:String?
    var arrays = [Around]()
    @IBOutlet weak var lbAround: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customBarRightButton()
    }
    override func decorate() {
            buttonTest(button: workAround, imageName: "quanhday")
            buttonTest(button: manageButton, imageName: "quanlyconviec")
            buttonTest(button: historyButton, imageName: "lichsu")
            lbLogo.textColor = .black
    }
    override func setupViewBase() {
        super.setupViewBase()
        self.title = "Home".localize
        lbLogo.text = "AnyTime".localize
        lbAround.text = "Around".localize
        lbManage.text = "Taskmanagement".localize
        lbHistory.text = "Taskhistory".localize
        lbHistory.font = fontSize.fontName(name: .medium, size: sizeFour)
        lbManage.font = fontSize.fontName(name: .medium, size: sizeFour)
        lbAround.font = fontSize.fontName(name: .medium, size: sizeFour)
    }
    func customBarRightButton(){
        let button = UIButton(type: .custom)
        button.setImage(Ionicons.iosMore.image(32).maskWithColor(color: UIColor.colorWithRedValue(redValue: 47, greenValue: 186, blueValue: 194, alpha: 1)), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.setTitleColor(UIColor.blue, for: .highlighted)
        button.titleEdgeInsets = UIEdgeInsetsMake(0,0,0,0)
        button.addTarget(self, action: #selector(HomeViewDisplayController.selectButton), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    func selectButton()  {
        navigationController?.pushViewController(MoreViewController(), animated: true)
    }
    
    func buttonTest(button:UIButton,imageName:String)  {
        let buttonWidth = button.bounds.size.width
        button.center = view.center
        let myImage = UIImage(named: imageName)?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        button.setImage(myImage, for: UIControlState.normal)
        button.tintColor = UIColor.white
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: buttonWidth/2, right: 0)
    }
    @IBAction func AroundButton(_ sender: Any) {
        let map = MapViewController(nibName: "MapViewController", bundle: nil)
            map.arrays = arrays
        navigationController?.pushViewController(map, animated: true)
    }
    @IBAction func ManageButton(_ sender: Any) {
        let manage = ManageViewController(nibName: NibManageViewController, bundle: nil)
        navigationController?.pushViewController(manage, animated: true)
    }
    @IBAction func HistoryButton(_ sender: Any) {
        navigationController?.pushViewController(ManagerHistoryViewController(), animated: true)
    }
}


