//
//  MoreViewController.swift
//  GV24
//
//  Created by HuyNguyen on 5/30/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class MoreViewController: BaseViewController {
    var arryMore:[String] = ["Thống kê công việc","Aboutus".localize,"Termsofuse".localize,"Language".localize, "Contact".localize]
    @IBOutlet weak var tbMore: UITableView!
    var userLogin:User?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tbMore.register(UINib(nibName:"MoreNameCell",bundle:nil), forCellReuseIdentifier: "moreNameCell")
        tbMore.register(UINib(nibName:"MoreCell",bundle:nil), forCellReuseIdentifier: "moreCell")
        tbMore.register(UINib(nibName:"NotifiCell",bundle:nil), forCellReuseIdentifier: "notifCell")
        self.userLogin = UserDefaultHelper.currentUser
    }
    override func setupViewBase() {
        self.title = "More".localize
        tbMore.reloadData()
    }
}
extension MoreViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1{
        return 1
        }else{
        return arryMore.count
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell:MoreNameCell = (tbMore.dequeueReusableCell(withIdentifier: "moreNameCell", for: indexPath) as? MoreNameCell)!
            let url = URL(string: (userLogin?.image)!)
            let data = try? Data(contentsOf: url!)
            if let imageData = data {
                let image = UIImage(data: imageData)
                DispatchQueue.main.async {
                    cell.avatar.image = image
                }
            }
            return cell
        }else if indexPath.section == 1{
            let cell:NotifiCell = (tbMore.dequeueReusableCell(withIdentifier: "notifCell", for: indexPath) as? NotifiCell)!
            return cell
        }else{
            let cell:MoreCell = (tbMore.dequeueReusableCell(withIdentifier: "moreCell", for: indexPath) as? MoreCell)!
            let lang = DGLocalization.sharedInstance.getCurrentLanguage()
            if lang.languageCode == "en" {
                cell.lbMore.text = arryMore[indexPath.row].localize
            }
            cell.lbMore.text = arryMore[indexPath.row].localize
            cell.textLabel?.font = UIFont(name: "SFUIText-Light", size: 13)
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
                navigationController?.pushViewController(ConstactViewController(), animated: true)
                break
            case 1:
                navigationController?.pushViewController(AboutViewController(), animated: true)
                break
            case 2:
                navigationController?.pushViewController(RuleViewController(), animated: true)
                break
            case 3:
                navigationController?.pushViewController(LanguageViewController(), animated: true)
                break
            case 4:
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
