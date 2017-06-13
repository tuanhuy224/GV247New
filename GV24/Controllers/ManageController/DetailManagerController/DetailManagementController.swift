//
//  DetailManagementController.swift
//  GV24
//
//  Created by HuyNguyen on 6/13/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class DetailManagementController: BaseViewController {
    var workPending:Work?
    @IBOutlet weak var detailManager: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        detailManager.register(UINib(nibName:"InforCell",bundle:nil), forCellReuseIdentifier: "inforCell")
        detailManager.register(UINib(nibName:"InfoDetailCell",bundle:nil), forCellReuseIdentifier: "infoDetailCell")
        detailManager.allowsSelection = false
        detailManager.separatorStyle = .none
    }
}
extension DetailManagementController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell:InforCell = detailManager.dequeueReusableCell(withIdentifier: "inforCell", for: indexPath) as! InforCell
            cell.lbGender.text = workPending?.stakeholders?.owner?.gender?.description
            cell.lbAddress.text = workPending?.stakeholders?.owner?.address?.name
            if workPending?.stakeholders?.owner?.gender == 1 {
                cell.lbGender.text = "Nam"
            }
            cell.lbGender.text = "Nữ"
            cell.lbPhone.text = workPending?.stakeholders?.owner?.phone
            let url = URL(string: (workPending?.stakeholders?.owner?.image)!)
            cell.imageProfile.kf.setImage(with: url)
            cell.avatar.kf.setImage(with: url)
            cell.lbName.text = workPending?.stakeholders?.owner?.name
            return cell
        }
        return UITableViewCell()
    }
}
extension DetailManagementController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 268
        }else{
            return 276
        }
    }
}
