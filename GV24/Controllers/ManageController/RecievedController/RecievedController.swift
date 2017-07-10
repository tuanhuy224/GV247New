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
        self.tbRecieved.rowHeight = UITableViewAutomaticDimension
        self.tbRecieved.estimatedRowHeight = 100.0
    }
    override func setupViewBase() {
        super.setupViewBase()
        self.title = "assigned".localize
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
            if processRecieved?.process?.id == WorkStatus.Direct.rawValue {
                cell.btChoose.isHidden = false
                cell.vSegment.isHidden = false
            }else{
                cell.btChoose.isEnabled = true
                cell.heightBtChoose.constant = 0
            }
            cell.nameUser.text = processRecieved?.stakeholders?.owner?.name
            cell.addressName.text = processRecieved?.stakeholders?.owner?.address?.name
            let url = URL(string: (processRecieved?.stakeholders?.owner?.image)!)
            if url == nil {
                cell.imageName.image = UIImage(named: "avatar")
            }else{
                DispatchQueue.main.async {
                    cell.imageName.kf.setImage(with: url)
                }
            }
            cell.delegate = self
            return cell
        case 1:
            let cell:InfoDetailCell = tbRecieved.dequeueReusableCell(withIdentifier: infoDetailCellID, for: indexPath) as! InfoDetailCell
            cell.lbDescription.text = "Description".localize
            cell.lbTitle.text = processRecieved?.info?.title
            cell.lbSubTitle.text = processRecieved?.info?.address?.name
            cell.lbComment.text = processRecieved?.info?.content
            cell.lbDate.text = "\(Date(isoDateString: (processRecieved?.workTime?.startAt)!).dayMonthYear)"
            cell.lbMoney.text = "\(processRecieved?.info?.salary ?? 0) $"
            cell.lbTime.text = String.convertISODateToString(isoDateStr: (self.processRecieved?.workTime!.startAt)!, format: "HH:mm a")! + " - " + String.convertISODateToString(isoDateStr: (self.processRecieved?.workTime!.endAt)!, format: "HH:mm a")!
            cell.lbAddress.text = processRecieved?.stakeholders?.owner?.address?.name
            
            return cell
        case 2:
            let cell:CancelCell = tbRecieved.dequeueReusableCell(withIdentifier: cancelCellID, for: indexPath) as! CancelCell
            cell.lbCancel.text = "Cancelthetask".localize
            cell.lbCancelDetail.text = "Youcancancelyouraccepted".localize
            cell.delegate = self
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
}
extension RecievedController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let navi = DetailManagementController(nibName: "DetailManagementController", bundle: nil)
            navi.workPending = processRecieved
            navigationController?.pushViewController(navi, animated: true)
            break
        default:
            break
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
            let alertC = AlertStandard.sharedInstance
            alertC.showAlertCt(controller: self, pushVC: ManageViewController(), title: "", message: "cancelWork".localize)
        }
    }
}
extension RecievedController:chooseWorkDelegate{
    func detailManagementDelegate() {
        let navi = DetailManagementController(nibName: "DetailManagementController", bundle: nil)
        navi.workPending = processRecieved
        navigationController?.pushViewController(navi, animated: true)
    }
}
