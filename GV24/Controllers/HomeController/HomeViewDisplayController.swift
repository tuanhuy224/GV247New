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


class HomeViewDisplayController: BaseViewController {
    var user:User?
    let url = "https://yukotest123.herokuapp.com/en/owner/getById"
    @IBOutlet weak var workAround: UIButton!
    @IBOutlet weak var manageButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var viewDisplay: UIView!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var lbLogo: UILabel!
    var titleAround:String?
    var arrays = [Around]()
    override func viewDidLoad() {
        super.viewDidLoad()
        print(UserDefaultHelper.getToken()!)
        self.customBarRightButton()
    }
    override func decorate() {
            buttonTest(button: workAround, imageName: "quanhday", titleImage: "SignIn".localize)
            buttonTest(button: manageButton, imageName: "quanlyconviec", titleImage: "SignIn".localize)
            buttonTest(button: historyButton, imageName: "lichsu", titleImage: "Back".localize)
        lbLogo.text = "Forgotpassword".localize
        lbLogo.textColor = UIColor.colorWithRedValue(redValue: 47, greenValue: 186, blueValue: 194, alpha: 1)
        loadData()
        
    }
    override func setupViewBase() {
        self.title = "Home".localize
        let lang = DGLocalization.sharedInstance.getCurrentLanguage()
        if lang.languageCode == "en" {
            lbLogo.text = "Forgotpassword".localize
        }else{
            lbLogo.text = "Forgotpassword".localize
        }
    }
    func loadData() {
        let url = "https://yukotest123.herokuapp.com/en/more/getTaskAround"
        let apiService = APIService.shared
        let param:[String:Double] = ["lng": 106.6882557,"lat": 10.7677238]
        //handleRefresh.endRefreshing()
        apiService.getAllAround(url: url, method: .get, parameters: param, encoding: URLEncoding.default) { (json, string) in
            if let jsonArray = json?.array{
                for data in jsonArray{
                    self.arrays.append(Around(json: data))
                }
            }
        }
    }
    func customBarRightButton(){
        let image = Ionicons.iosMore.image(24).maskWithColor(color: UIColor.colorWithRedValue(redValue: 24, greenValue: 179, blueValue: 110, alpha: 1))
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20.0)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.setTitleColor(UIColor.brown, for: .highlighted)
        button.addTarget(self, action: #selector(HomeViewDisplayController.selectButton), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        
    }
    func selectButton()  {
        navigationController?.pushViewController(MoreViewController(), animated: true)
    }
    
    func buttonTest(button:UIButton,imageName:String, titleImage:String)  {
        let imageSize : CGFloat = 30
        let gap : CGFloat = 10
        let borderSize : CGFloat = 10
        let textHeight : CGFloat = 20
        let imageOrigin : CGFloat = borderSize + gap
        let textTop : CGFloat = imageOrigin + imageSize + gap
        let textBottom : CGFloat = borderSize + gap
        let imageBottom : CGFloat = textBottom + textHeight + gap
        button.frame = CGRect(x: 0, y: 0, width: button.frame.size.width, height: button.frame.size.height)
        button.center = view.center
        let myImage = UIImage(named: imageName)?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        button.setImage(myImage, for: UIControlState.normal)
        button.tintColor = UIColor.white
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: imageOrigin + gap, bottom: imageBottom, right: imageOrigin + gap)
        button.titleLabel?.font = UIFont(name: "SFUIText-Light", size: 10)
        button.setTitle(titleImage.localize, for: UIControlState.normal)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
        button.setTitleColor(UIColor.white, for: UIControlState.highlighted)
        button.titleEdgeInsets = UIEdgeInsets(top: textTop, left: -myImage!.size.width, bottom: textBottom, right: 0.0)
    }
    
    @IBAction func AroundButton(_ sender: Any) {
        let around = WorkAroundController(nibName: "WorkAroundController", bundle: nil)
            around.arrays = arrays
        navigationController?.pushViewController(around, animated: true)
    }
    @IBAction func ManageButton(_ sender: Any) {
        let manage = ManageViewController(nibName: "ManageViewController", bundle: nil)
        navigationController?.pushViewController(manage, animated: true)
    }
    @IBAction func HistoryButton(_ sender: Any) {
        navigationController?.pushViewController(ManagerHistoryViewController(), animated: true)
    }
    
    @IBAction func showMap(_ sender: Any) {
        navigationController?.pushViewController(MapViewController(), animated: true)
    }
}


