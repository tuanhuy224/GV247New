//
//  MoreViewController.swift
//  GV24
//
//  Created by HuyNguyen on 5/30/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire
import Firebase
import FirebaseInstanceID
import IoniconsSwift

class MoreViewController: BaseViewController {
    var arryMore:[String] = ["AboutUsTitle","TermsofuseTitle", "Contact"]
    @IBOutlet weak var tbMore: UITableView!
    var userLogin:User?
    var isnotification:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        tbMore.on_register(type: WorkDetailCell.self)
        tbMore.on_register(type: MoreCell.self)
        tbMore.on_register(type: NotifiCell.self)
        tbMore.on_register(type: FollowCell.self)
        tbMore.on_register(type: HeaderCell.self)
        self.userLogin = UserDefaultHelper.currentUser
        self.tbMore.rowHeight = UITableViewAutomaticDimension
        self.tbMore.estimatedRowHeight = 100.0
        tbMore.separatorStyle = .none
        customLeftButton()
    }
    override func setupViewBase() {
        self.title = "More".localize
        tbMore.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tbMore.reloadData()
        
    }
    
    static func cornerButton(_ button: UIButton, _ radius: CGFloat) {
        button.layer.cornerRadius = radius
        button.clipsToBounds = true
    }
    func customLeftButton(){
        let button = UIButton(type: .custom)
        button.setImage(Ionicons.iosCloseEmpty.image(32).maskWithColor(color: UIColor.colorWithRedValue(redValue: 74, greenValue: 74, blueValue: 74, alpha: 1)), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.titleEdgeInsets = UIEdgeInsetsMake(0,0,0,0)
        button.addTarget(self, action: #selector(MoreViewController.selectButton), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    func selectButton() {
        self.dismiss(animated: true, completion: nil)
    }

}
extension MoreViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return arryMore.count
        }else{
            return 1
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell:WorkDetailCell = self.tbMore.on_dequeue(idxPath: indexPath)
                cell.nameUser.text = userLogin?.name
                cell.btAction.layer.cornerRadius = 4
                cell.btAction.backgroundColor = UIColor.colorWithRedValue(redValue: 19, greenValue: 111, blueValue: 167, alpha: 1)
                cell.btAction.setTitle("Generalstatistic".localize, for: .normal)
                cell.btAction.setTitleColor(.white, for: .normal)
                cell.addressName.text = userLogin?.nameAddress
            guard let img = userLogin?.image else { return  cell }
            let url = URL(string: img)
            if url == nil {
                cell.imageName.image = UIImage(named: "avatar")
            }else{
                cell.imageName.kf.setImage(with: url)
            }
                //cell.btChoose.setTitle("Generalstatistic".localize, for: .normal)
                cell.btChoose.setTitleColor(.black, for: .normal)
                cell.vSegment.isHidden = false
                cell.btChoose.isHidden = false
                cell.delegateWork = self
                cell.heightHeader.constant = 0
            return cell
        }else if indexPath.section == 1{
            let cell:NotifiCell = tbMore.on_dequeue(idxPath: indexPath)
                cell.btChooseLanguage.setTitle("Language".localize, for: .normal)
                cell.lbNotif.text = "Notification".localize
                cell.delegate = self
                cell.notiDelegate = self
            return cell
        }else if indexPath.section == 2{
            let cell:MoreCell = tbMore.on_dequeue(idxPath: indexPath)
            let lang = DGLocalization.sharedInstance.getCurrentLanguage()
            if lang.languageCode == "en" {
                cell.lbMore.text = arryMore[indexPath.row].localize
            }

        
            cell.lbMore.text = arryMore[indexPath.row].localize
            cell.textLabel?.font = UIFont(name: "SFUIText-Light", size: 13)
            return cell
        }else if indexPath.section == 3{
            let cell:FollowCell = tbMore.on_dequeue(idxPath: indexPath)
            cell.btFollowAc.setTitle("shareGv24".localize, for: .normal)
            cell.btFacebookAc.setTitle("followUs".localize, for: .normal)
            cell.btLogOut.backgroundColor = UIColor.colorWithRedValue(redValue: 204, greenValue: 204, blueValue: 204, alpha: 1)
            cell.btLogOut.layer.cornerRadius = 4
            cell.clipsToBounds = true
            
            cell.btLogOut.setTitle("SignOut".localize, for: .normal)
            cell.btLogOut.titleLabel?.textAlignment = .center
            
            cell.delegate = self
            return cell
        }else{
            let cell:HeaderCell = tbMore.on_dequeue(idxPath: indexPath)
            return cell
        }
    }
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 20
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if indexPath.section == 2 {
            switch indexPath.row {
            case 0:
                navigationController?.pushViewController(AboutViewController(), animated: true)
                break
            case 1:
                navigationController?.pushViewController(RuleViewController(), animated: true)
                break
            case 2:
                navigationController?.pushViewController(ConstactViewController(), animated: true)
                break
            default:
                break
            }
        }else if indexPath.section == 0{
            navigationController?.pushViewController(InformationViewController(), animated: true)
        }
    }
    
    func shareToAirDrop() {
        let text = "ShareApp".localize
        
        // set up activity view controller
        let textToShare = [text as Any]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: [])
        
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won’t crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func shareToFacebook() {
        guard let url = URL(string: "fb://profile/122998571630965") else {return}
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        } else {
            UIApplication.shared.openURL(URL(string: "https://www.facebook.com/Ng%C6%B0%E1%BB%9Di-Gi%C3%BAp-Vi%E1%BB%87c-247-122998571630965/")!)
        }
    }
}


extension MoreViewController:changeLanguageDelegate{
    func changeLanguage() {
        navigationController?.pushViewController(LanguageViewController(), animated: true)
    }
}

extension MoreViewController:LogOutDelegate{
    func logOut() {
        
        AlertStandard.sharedInstance.showAlertCt(controller: self, pushVC: LoginView(), title: "", message: "LogOutAlert".localize) {
            _ = UserDefaultHelper().removeUserDefault()
            guard let window = UIApplication.shared.keyWindow else{return}
            let vc = LoginView()
            //let navi = UINavigationController(rootViewController: vc)
            window.rootViewController = vc
        }

    }
    
    func cellDidPressedShareToAirDrop(_ cell: FollowCell) {
        shareToAirDrop()
    }
    
    func cellDidPressedShareToFacebook(_ cell: FollowCell) {
        shareToFacebook()
    }
}
extension MoreViewController:clickChooseWorkID{
    func chooseAction() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        navigationController?.pushViewController(StatisticViewController(), animated: true)
        MBProgressHUD.hide(for: self.view, animated: true)
    }
}
extension MoreViewController:notificationDelegate{
    func notificationAnnotation(noti: UISwitch) {
        guard let tokenString = UserDefaultHelper.getToken() else {return}
        let header = ["Content-Type":"application/x-www-form-urlencoded","hbbgvauth": tokenString]
        guard let token = InstanceID.instanceID().token() else {return}
        let parameter = ["device_token":"\(token)"]
        let apiClient = APIService.shared
        if noti.isOn == true{
            self.isnotification = noti.isOn
            apiClient.postReserve(url: APIPaths().maidOnAnnouncement(), method: .post, parameters: parameter, header: header, completion: { (json, error) in
                
            })
        }else{
            apiClient.postReserve(url: APIPaths().maidOffAnnouncement(), method: .post, parameters: [:], header: header, completion: { (json, error) in
                
            })
        }
    }
}

