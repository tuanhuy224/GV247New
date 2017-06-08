//
//  WaittingController.swift
//  GV24
//
//  Created by HuyNguyen on 6/5/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Kingfisher

class WaittingController: BaseViewController {
    var owner:Owner?
    @IBOutlet weak var tbWaitting: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tbWaitting.register(UINib(nibName:"WorkDetailCell",bundle:nil), forCellReuseIdentifier: "workDetailCell")
        tbWaitting.register(UINib(nibName:"InfoDetailCell",bundle:nil), forCellReuseIdentifier: "infoDetailCell")
        tbWaitting.register(UINib(nibName:"WaittingCell",bundle:nil), forCellReuseIdentifier: "waittingCell")
        tbWaitting.allowsSelection = false
        test()
    }
    
    override func decorate() {
        
    }
    func test() {
       
    }
    override func setupViewBase() {
        self.title = "Đang chờ"
        if UserDefaultHelper.ownerUser != nil {
            owner = UserDefaultHelper.ownerUser
            
        }
    }
}
extension WaittingController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell:WorkDetailCell = tbWaitting.dequeueReusableCell(withIdentifier: "workDetailCell", for: indexPath) as! WorkDetailCell
            cell.nameUser.text = owner?.username
            cell.addressName.text = owner?.name
            if owner?.image == nil {
                return cell
            }
            if let url = URL(string: (owner?.image)!){
                DispatchQueue.main.async {
                     cell.imageName.kf.setImage(with: url)
                }
            }
            return cell
        }else if indexPath.section == 1{
            let cell:InfoDetailCell = tbWaitting.dequeueReusableCell(withIdentifier: "infoDetailCell", for: indexPath) as! InfoDetailCell
            return cell
        }else{
            let cell:WaittingCell = tbWaitting.dequeueReusableCell(withIdentifier: "waittingCell", for: indexPath) as! WaittingCell
            return cell
        }
        
    }
}
extension WaittingController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 80
        }else if indexPath.section == 1{
            return 276
        }else{
            return 64
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
}
