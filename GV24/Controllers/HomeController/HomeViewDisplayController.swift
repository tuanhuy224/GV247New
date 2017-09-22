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
import Kingfisher

class HomeViewDisplayController: BaseViewController{
    var user:User?
    
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbHistory: UILabel!
    @IBOutlet weak var lbManage: UILabel!
    @IBOutlet weak var workAround: UIButton!
    @IBOutlet weak var manageButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var viewDisplay: UIView!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var lbLogo: UILabel!
    @IBOutlet weak var btAvatar: UIButton!
    
    var titleAround:String?
    var arrays = [Around]()
    @IBOutlet weak var lbAround: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.customBarRightButton()
    }
    
    func cornerButton(_ button: UIButton, _ radius: CGFloat) {
        button.layer.cornerRadius = radius
        button.clipsToBounds = true
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
    }
    
    @IBAction func btAvatarAction(_ sender: Any) {
//        let navi = UINavigationController(rootViewController: MoreViewController())
//        self.present(navi, animated: true, completion: nil)
        let navi = MoreViewController()
        navigationController?.pushViewController(navi, animated: true)
    }
    
    override func setupViewBase() {
        super.setupViewBase()
        self.title = "Home".localize
        navigationController?.isNavigationBarHidden = true
        workAround.setTitle("Around".localize, for: .normal)
        manageButton.setTitle("Taskmanagement".localize, for: .normal)
        historyButton.setTitle("Taskhistory".localize, for: .normal)
        workAround.tintColor = .white
        manageButton.tintColor = .white
        historyButton.tintColor = .white
        workAround.backgroundColor = AppColor.homeButton1
        manageButton.backgroundColor = AppColor.homeButton2
        historyButton.backgroundColor = AppColor.homeButton3
        cornerButton(workAround, 8)
        cornerButton(manageButton, 8)
        cornerButton(historyButton, 8)
        cornerButton(btAvatar, btAvatar.frame.size.width/2)
        guard let urlImage = UserDefaultHelper.currentUser?.image else {return}
        let url = URL(string: urlImage)
        btAvatar.kf.setImage(with: url, for: .normal, placeholder: UIImage(named: "avatar"), options: nil, progressBlock: nil, completionHandler: nil)


    }
    
    
    func customBarRightButton(){
        let button = UIButton(type: .custom)
        button.setImage(Ionicons.iosMore.image(32).maskWithColor(color: AppColor.backButton), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.setTitleColor(UIColor.blue, for: .highlighted)
        button.titleEdgeInsets = UIEdgeInsetsMake(0,0,0,0)
        button.addTarget(self, action: #selector(HomeViewDisplayController.selectButton), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    func selectButton()  {
//        let navi = UINavigationController(rootViewController: MoreViewController())
//        self.present(navi, animated: true, completion: nil)
        let navi = MoreViewController()
        navigationController?.pushViewController(navi, animated: true)
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
        self.navigationController?.pushViewController(WorksAroundViewController(), animated: true)
    }
    @IBAction func ManageButton(_ sender: Any) {
        //let manage = ManageViewController(nibName: NibManageViewController, bundle: nil)
        navigationController?.pushViewController(PageViewController(), animated: true)
    }
    @IBAction func HistoryButton(_ sender: Any) {
        navigationController?.pushViewController(ManagerHistoryViewController(), animated: true)
    }
}


