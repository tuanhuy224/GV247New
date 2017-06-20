//
//  RecievedController.swift
//  GV24
//
//  Created by HuyNguyen on 6/13/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class RecievedController: BaseViewController {
    var processRecieved:Work?
    @IBOutlet weak var tbRecieved: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tbRecieved.register(UINib(nibName:NibWorkDetailCell,bundle:nil), forCellReuseIdentifier: workDetailCellID)
        tbRecieved.register(UINib(nibName:NibInfoDetailCell,bundle:nil), forCellReuseIdentifier: infoDetailCellID)
        tbRecieved.register(UINib(nibName:NibCancelCell,bundle:nil), forCellReuseIdentifier: cancelCellID)
        tbRecieved.separatorStyle = .none
        tbRecieved.reloadData()
    }
    override func setupViewBase() {
        super.setupViewBase()
        self.title = "\(processRecieved?.info?.title ?? "")".localize
        self.navigationController?.navigationBar.topItem?.title = ""
    }

}
extension RecievedController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            let cell:WorkDetailCell = tbRecieved.dequeueReusableCell(withIdentifier: workDetailCellID, for: indexPath) as! WorkDetailCell
            cell.nameUser.text = processRecieved?.stakeholders?.owner?.name
            print(processRecieved!.id!)
            cell.addressName.text = processRecieved?.stakeholders?.owner?.address?.name
            let url = URL(string: (processRecieved?.stakeholders?.owner?.image)!)
            cell.imageName.kf.setImage(with: url)
            return cell
        case 1:
            let cell:InfoDetailCell = tbRecieved.dequeueReusableCell(withIdentifier: infoDetailCellID, for: indexPath) as! InfoDetailCell
            cell.lbTitle.text = processRecieved?.info?.title
            cell.lbSubTitle.text = processRecieved?.info?.address?.name
            cell.lbComment.text = processRecieved?.info?.content
            cell.lbDate.text = "\(Date(isoDateString: (processRecieved?.workTime?.startAt)!).dayMonthYear) \(" - ") \(Date(isoDateString: (processRecieved?.workTime?.endAt)!).dayMonthYear)"
            cell.lbMoney.text = "\(processRecieved?.info?.salary ?? 0) $"
            return cell
        case 2:
            let cell:CancelCell = tbRecieved.dequeueReusableCell(withIdentifier: cancelCellID, for: indexPath) as! CancelCell
            cell.delegate = self
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
}
extension RecievedController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return CGFloat(heightConstantWorkDetailCell)
        case 1:
            return 284
        default:
            return 172
        }
    }
}
extension RecievedController:CancelWorkDelegate{
    func CancelButton() {
        let parameter = ["id":processRecieved!.id!]
        let header = ["hbbgvauth":"\(UserDefaultHelper.getToken()!)"]
        let apiClient = APIService.shared
        MBProgressHUD.showAdded(to: self.view, animated: true)
        apiClient.deleteReserve(url: APIPaths().urlCancelTask(), method: .delete, parameters: parameter, header: header) { (json, string) in
            MBProgressHUD.hide(for: self.view, animated: true)
            print(string!)
            let alertC = AlertStandard.sharedInstance
            alertC.showAlertCt(controller: self, pushVC: ManageViewController(), title: "", message: "cancelWork".localize)
        }
    }
}

