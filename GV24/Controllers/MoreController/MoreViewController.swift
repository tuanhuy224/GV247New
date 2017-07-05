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

class MoreViewController: BaseViewController {
    var arryMore:[String] = ["AboutUsTitle","TermsofuseTitle", "Contact"]
    @IBOutlet weak var tbMore: UITableView!
    var userLogin:User?
    var isnotification:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        tbMore.register(UINib(nibName:NibWorkDetailCell,bundle:nil), forCellReuseIdentifier: workDetailCellID)
        tbMore.register(UINib(nibName:NibMoreCell,bundle:nil), forCellReuseIdentifier: MoreCellID)
        tbMore.register(UINib(nibName:NibNotifiCell,bundle:nil), forCellReuseIdentifier: notifCellID)
        tbMore.register(UINib(nibName:NibFollowCell,bundle:nil), forCellReuseIdentifier: followCell)
        tbMore.register(UINib(nibName:NibHeaderCell,bundle:nil), forCellReuseIdentifier: headerCellID)
        self.userLogin = UserDefaultHelper.currentUser
        self.tbMore.rowHeight = UITableViewAutomaticDimension
        self.tbMore.estimatedRowHeight = 100.0
        tbMore.separatorStyle = .none
    }
    override func setupViewBase() {
        self.title = "More".localize
        tbMore.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tbMore.reloadData()
        
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
            let cell:WorkDetailCell = tbMore.dequeueReusableCell(withIdentifier: workDetailCellID, for: indexPath) as! WorkDetailCell
                cell.nameUser.text = userLogin?.username
                cell.addressName.text = userLogin?.nameAddress
            if let url = URL(string: userLogin!.image!){
                cell.imageName.kf.setImage(with: url)
            }
                cell.btChoose.setTitle("Generalstatistic".localize, for: .normal)
                cell.btChoose.setTitleColor(.black, for: .normal)
                cell.vSegment.isHidden = false
                cell.btChoose.isHidden = false
                cell.delegateWork = self
                cell.heightHeader.constant = 0
            return cell
        }else if indexPath.section == 1{
            let cell:NotifiCell = (tbMore.dequeueReusableCell(withIdentifier: notifCellID, for: indexPath) as? NotifiCell)!
                cell.btChooseLanguage.setTitle("Language".localize, for: .normal)
                cell.lbNotif.text = "Announcement".localize
                cell.delegate = self
                cell.notiDelegate = self
            return cell
        }else if indexPath.section == 2{
            let cell:MoreCell = (tbMore.dequeueReusableCell(withIdentifier: MoreCellID, for: indexPath) as? MoreCell)!
            let lang = DGLocalization.sharedInstance.getCurrentLanguage()
            if lang.languageCode == "en" {
                cell.lbMore.text = arryMore[indexPath.row].localize
            }

        
            cell.lbMore.text = arryMore[indexPath.row].localize
            cell.textLabel?.font = UIFont(name: "SFUIText-Light", size: 13)
            return cell
        }else if indexPath.section == 3{
            let cell:FollowCell = (tbMore.dequeueReusableCell(withIdentifier: followCell, for: indexPath) as? FollowCell)!
            cell.btFollowAc.setTitle("shareGv24".localize, for: .normal)
            cell.btFacebookAc.setTitle("followUs".localize, for: .normal)
            cell.btLogOut.setTitle("Logout".localize, for: .normal)
            cell.delegate = self
            return cell
        }else{
            let cell:HeaderCell = (tbMore.dequeueReusableCell(withIdentifier: headerCellID, for: indexPath) as? HeaderCell)!
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
}
extension MoreViewController:changeLanguageDelegate{
    func changeLanguage() {
        navigationController?.pushViewController(LanguageViewController(), animated: true)
    }
}

extension MoreViewController:LogOutDelegate{
    func logOut() {
        if UserDefaultHelper().removeUserDefault() == true{
            AlertStandard.sharedInstance.showAlertSetRoot(controller: self, pushVC: LoginView(), title: "", message: "LogOutAlert".localize)
        }
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
        let header = ["Content-Type":"application/x-www-form-urlencoded","hbbgvauth":"\(UserDefaultHelper.getToken()!)"]
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

