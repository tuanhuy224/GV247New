//
//  BaseViewController.swift
//  GV24
//
//  Created by admin on 5/24/17.
//  Copyright © 2017 admin. All rights reserved.
//
import UIKit
import Alamofire

class BaseViewController: UIViewController {
    let notificationIdentifier: String = "NotificationIdentifier"
    let install = NetworkStatus.sharedInstance
    var islog = false
    //    var toDate: Date = Date()
    var isChange: Bool = false
    var currentLanguage:Int?
    var isLoginWhenChangeToken:Bool = false
    var viewControllerLogin = UIViewController()
    var viewNetwork:UIView?
    var lbViewNetwork:UILabel?
    let backItem = UIBarButtonItem()
    var actionSheet: UIAlertController!
    let loadingView = LoadingView()
    //var dGlocale = DGLocalization()
    let net = NetworkReachabilityManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        DGLocalization.sharedInstance.Delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.setupNavi), name: NSNotification.Name(rawValue: notificationIdentifier), object: nil)
        self.decorate()
        print("====Current self:\(self)====")
        net?.startListening()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupViewBase()
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:fontSize.fontName(name: .bold, size: sizeSix)]
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back".localize, style: UIBarButtonItemStyle.done, target: nil, action: nil)
        self.navigationController?.navigationBar.isTranslucent = false
        if (install.reachabilityManager?.isReachable)!  {
            checkTokenApp()
        }else{
            
            AlertStandard.sharedInstance.showAlert(controller: self, title: "", message: "Nointernetconnection".localize)
        }
        
        print("++++view display:\(self)+++++++")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupNavi() {
        BackButtonItem()
    }
    func setupViewBase() {
        
    }
    
    
    
    func BackButtonItem() {
        let backItem = UIBarButtonItem()
        backItem.title = "Back".localize
        navigationItem.backBarButtonItem = backItem
    }
    func decorate(){}
    func displayNetwork(){
        viewNetwork = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
        lbViewNetwork = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 30))
        lbViewNetwork?.text = "Nointernetconnection".localize
        lbViewNetwork?.textAlignment = .center
        lbViewNetwork?.tintColor = UIColor.white
        lbViewNetwork?.backgroundColor = UIColor.colorWithRedValue(redValue: 253, greenValue: 190, blueValue: 78, alpha: 1)
        viewNetwork?.addSubview(lbViewNetwork!)
    }
    func checkTokenApp() {
        
        
        guard let token = UserDefaultHelper.getToken() else{return}
        let header = ["Content-Type":"application/x-www-form-urlencoded","hbbgvauth":"\(token)"]
        let apiClient = APIService.shared
        apiClient.getUrl(url: APIPaths().maidCheckToken(), param: [:], header: header) { (json, error) in
            if json?["message"] != "SUCCESS" {
                let alert = AlertStandard.sharedInstance
                alert.showAlertLogin(controller: self, pushVC: LoginView(), title: "", message: "Youraccountwasaccessedfromanotherdevice".localize, buttonTitle:"" , completion: {
                    
                    _ = UserDefaultHelper().removeUserDefault()
                    let loginController = LoginView()
                    loginController.viewControllerLogin = self
                    loginController.isLoginWhenChangeToken = true
                    guard let window = UIApplication.shared.keyWindow else{return}
                    let navi = UINavigationController(rootViewController: loginController)
                    window.rootViewController = navi
                })
                
            }
        }
    }
}
extension BaseViewController:DGLocalizationDelegate{
    func languageDidChanged(to: (String)) {
        if to == "en" {
            currentLanguage = 1
        }else{
            currentLanguage = 0
        }
    }
}
