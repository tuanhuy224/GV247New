//
//  DetailOwnerViewController.swift
//  GV24
//
//  Created by HuyNguyen on 6/25/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Kingfisher

class DetailOwnerViewController: BaseViewController {
    var owner = Work()
    @IBOutlet weak var tbOwner: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tbOwner.register(UINib(nibName:NibInforCell,bundle:nil), forCellReuseIdentifier: inforCellID)
        tbOwner.register(UINib(nibName:NibInforOwnerCell,bundle:nil), forCellReuseIdentifier: InforOwnerCellID)
        self.tbOwner.rowHeight = UITableViewAutomaticDimension
        self.tbOwner.estimatedRowHeight = 100.0
    }
    override func setupViewBase() {
        super.setupViewBase()
        self.navigationItem.title = owner.stakeholders?.owner?.name?.localize
    }
    fileprivate func ownerCell(cell:InforCell){
        cell.lbName.text = owner.stakeholders?.owner?.username
         let image = URL(string: (owner.stakeholders?.owner?.image)!)
        if image == nil {
            DispatchQueue.main.async {
                cell.avatar.image = UIImage(named: "avatar")
            }
        }else{
            DispatchQueue.main.async {
                cell.avatar.kf.setImage(with: image)
            }
        }
        
        cell.imageProfile.kf.setImage(with: image)
        if owner.stakeholders?.owner?.gender == 1 {
            cell.lbGender.text = "Girl".localize
        }else{
            cell.lbGender.text = "Boy".localize
        }
        cell.lbAddress.text = owner.stakeholders?.owner?.address?.name
        cell.lbPhone.text = owner.stakeholders?.owner?.phone
        cell.lbAge.text = owner.stakeholders?.owner?.email
    }
}
extension DetailOwnerViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:InforCell = tbOwner.dequeueReusableCell(withIdentifier: inforCellID, for: indexPath) as! InforCell
        self.ownerCell(cell: cell)
        return cell
    }
}

