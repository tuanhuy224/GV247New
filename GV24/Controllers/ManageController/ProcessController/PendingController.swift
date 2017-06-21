//
//  PendingController.swift
//  GV24
//
//  Created by HuyNguyen on 6/13/17.
//  Copyright © 2017 admin. All rights reserved.
//
import UIKit
class PendingController: BaseViewController {
    @IBOutlet weak var tbPending: UITableView!
    var processPending:Work?
    override func viewDidLoad() {
        super.viewDidLoad()
        tbPending.register(UINib(nibName:NibWorkDetailCell,bundle:nil), forCellReuseIdentifier: workDetailCellID)
        tbPending.register(UINib(nibName:NibInfoDetailCell,bundle:nil), forCellReuseIdentifier: infoDetailCellID)
        tbPending.register(UINib(nibName:NibCancelCell,bundle:nil), forCellReuseIdentifier: cancelCellID)
        tbPending.separatorStyle = .none
    }
    override func setupViewBase() {
        super.setupViewBase()
        self.title = "\(processPending?.info?.title ?? "")".localize
        self.navigationController?.navigationBar.topItem?.title = ""
    }
}
extension PendingController:UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            let cell:WorkDetailCell = tbPending.dequeueReusableCell(withIdentifier: workDetailCellID, for: indexPath) as! WorkDetailCell
            cell.nameUser.text = processPending?.stakeholders?.owner?.name
            cell.delegate = self
            cell.addressName.text = processPending?.stakeholders?.owner?.address?.name
            let url = URL(string: (processPending?.stakeholders?.owner?.image)!)
            cell.imageName.kf.setImage(with: url)
            return cell
        case 1:
            let cell:InfoDetailCell = tbPending.dequeueReusableCell(withIdentifier: infoDetailCellID, for: indexPath) as! InfoDetailCell
            cell.lbTitle.text = processPending?.info?.title
            cell.lbSubTitle.text = processPending?.info?.address?.name
            cell.lbComment.text = processPending?.info?.content
            cell.lbDate.text = "\(Date(isoDateString: (processPending?.workTime?.startAt)!).dayMonthYear) \(" - ") \(Date(isoDateString: (processPending?.workTime?.endAt)!).dayMonthYear)"
            cell.lbMoney.text = "\(processPending?.info?.salary ?? 0) $"
            cell.lbTime.text = "\(Date(isoDateString: (self.processPending?.workTime!.startAt)!).hourMinute) \("-") \(Date(isoDateString: (self.processPending?.workTime!.endAt)!).hourMinute)"
            return cell
        case 2:
            let cell:CancelCell = tbPending.dequeueReusableCell(withIdentifier: cancelCellID, for: indexPath) as! CancelCell
            cell.lbCancelDetail.isHidden = true
            cell.delegate = self
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
}
extension PendingController:UITableViewDelegate{
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
extension PendingController:chooseWorkDelegate{
    func detailManagementDelegate() {
        let navi = DetailManagementController(nibName: "DetailManagementController", bundle: nil)
        navi.workPending = processPending
        navigationController?.pushViewController(navi, animated: true)
    }
}
extension PendingController:CancelWorkDelegate{
    func CancelButton() {
        let parameter = ["id":processPending!.id!]
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
