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
        detailManager.register(UINib(nibName:NibInforCell,bundle:nil), forCellReuseIdentifier: inforCellID)
        detailManager.register(UINib(nibName:NibInforOwnerCell,bundle:nil), forCellReuseIdentifier: InforOwnerCellID)
        detailManager.allowsSelection = false
        detailManager.separatorStyle = .none
    }
    override func setupViewBase() {
        super.setupViewBase()
        self.navigationItem.title = "Information".localize
    }
    // Mark: - custom cell for detail management
    func InforCellConfigure(cell:InforCell){
        cell.lbGender.text = workPending?.stakeholders?.owner?.gender?.description
        cell.lbAddress.text = workPending?.stakeholders?.owner?.address?.name
        if workPending?.stakeholders?.owner?.gender == 1 {
            cell.lbGender.text = enumGender.Boy.rawValue
        }
        cell.lbGender.text = enumGender.Girl.rawValue
        cell.lbPhone.text = workPending?.stakeholders?.owner?.phone
        let url = URL(string: (workPending?.stakeholders?.owner?.image)!)
        cell.imageProfile.kf.setImage(with: url)
        cell.avatar.kf.setImage(with: url)
        cell.lbName.text = workPending?.stakeholders?.owner?.name
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
            let cell:InforCell = detailManager.dequeueReusableCell(withIdentifier: inforCellID, for: indexPath) as! InforCell
            self.InforCellConfigure(cell: cell)
            return cell
        }else{
            let cell:InforOwnerCell = detailManager.dequeueReusableCell(withIdentifier: InforOwnerCellID, for: indexPath) as! InforOwnerCell
            cell.delegate = self
            return cell
        }
    }
}
extension DetailManagementController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 307
        }else{
            return 246
        }
    }
}
extension DetailManagementController:ReportDelegate{
    func report() {
        let navi = ReportController(nibName: "ReportController", bundle: nil)
        navi.work = workPending!
        navigationController?.pushViewController(navi, animated: true)
    }
}
