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
        detailManager.separatorStyle = .none
        self.detailManager.rowHeight = UITableViewAutomaticDimension
        self.detailManager.estimatedRowHeight = 100.0
    }
    override func setupViewBase() {
        super.setupViewBase()
        detailManager.reloadData()
        self.navigationItem.title = "Applicantprofile".localize
    }
    // Mark: - custom cell for detail management
    func InforCellConfigure(cell:InforCell){
        cell.workPending = workPending
        cell.bottomAge.constant = 0
        cell.topHeightAge.constant = 0
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
            cell.lbComment.text = "comment".localize.uppercased()
            cell.btReport.setTitle("report".localize, for: .normal)
            cell.lbCommentText.text = "nocomment".localize
            cell.btReport.setTitleColor(AppColor.backButton, for: .normal)

            cell.delegate = self
            return cell
        }
    }
}
extension DetailManagementController:ReportDelegate{
    func report() {
        let navi = ReportController(nibName: "ReportController", bundle: nil)
        if UserDefaultHelper.getToken() == nil {
            return
        }else{
            navi.work = workPending!
            navigationController?.pushViewController(navi, animated: true)
        }
        
    }
}
