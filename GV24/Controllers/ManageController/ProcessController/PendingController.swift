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
        self.tbPending.rowHeight = UITableViewAutomaticDimension
        self.tbPending.estimatedRowHeight = 100.0
    }
    override func setupViewBase() {
        super.setupViewBase()
        self.title = "waiting".localize
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
                cell.btChoose.setTitle("Selectthiswork".localize, for: .normal)
            if processPending?.process?.id == WorkStatus.Direct.rawValue {
                cell.btChoose.isHidden = false
                cell.delegateRequest = self
                cell.vSegment.isHidden = false
            }else{
                cell.btChoose.isEnabled = true
                cell.heightBtChoose.constant = 0
            }
            cell.nameUser.text = processPending?.stakeholders?.owner?.name
            cell.delegate = self
            cell.addressName.text = processPending?.stakeholders?.owner?.address?.name
            let url = URL(string: (processPending?.stakeholders?.owner?.image)!)
            if url == nil {
                cell.imageName.image = UIImage(named: "avatar")
            }else{
                DispatchQueue.main.async {
                    cell.imageName.kf.setImage(with: url)
                }
            }
            return cell
        case 1:
            let cell:InfoDetailCell = tbPending.dequeueReusableCell(withIdentifier: infoDetailCellID, for: indexPath) as! InfoDetailCell
            cell.lbDescription.text = "Description".localize
            cell.lbTitle.text = processPending?.info?.title
            cell.lbSubTitle.text = processPending?.info?.workName?.name
            cell.lbComment.text = processPending?.info?.content
            cell.lbDate.text = "\(Date(isoDateString: (processPending?.workTime?.endAt)!).dayMonthYear)"
            cell.lbMoney.text = "\(processPending?.info?.salary ?? 0) VND"
            cell.lbTime.text = String.convertISODateToString(isoDateStr: (self.processPending?.workTime!.startAt)!, format: "HH:mm a")! + " - " + String.convertISODateToString(isoDateStr: (self.processPending?.workTime!.endAt)!, format: "HH:mm a")!
            cell.lbAddress.text = processPending?.info?.address?.name
            return cell
        case 2:
            let cell:CancelCell = tbPending.dequeueReusableCell(withIdentifier: cancelCellID, for: indexPath) as! CancelCell
            cell.lbCancelDetail.isHidden = true
            if processPending?.process?.id == WorkStatus.Direct.rawValue {
                cell.lbCancel.text = "Refusework".localize
            }else{
                cell.lbCancel.text = "CancelTask".localize
            }
            cell.lbCancelDetail.text = "Youcancancelyouraccepted".localize
            cell.delegate = self
            //cell.denyDelegate = self
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
}
extension PendingController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let navi = DetailManagementController(nibName: "DetailManagementController", bundle: nil)
            navi.workPending = processPending
            navigationController?.pushViewController(navi, animated: true)
            break
        default:
            break
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
        if processPending?.process?.id == WorkStatus.Direct.rawValue{
            self.loadingView.show()
            guard let ownerId = processPending?.stakeholders?.owner?.id else {return}
            guard let taskID = processPending?.id else {return}
            let parameter = ["id":taskID,"ownerId":"\(ownerId)"]
            let header = ["Content-Type":"application/x-www-form-urlencoded","hbbgvauth":"\(UserDefaultHelper.getToken()!)"]
            let apiClient = APIService.shared
            let alertC = AlertStandard.sharedInstance
            self.loadingView.close()
            alertC.showAlertCt(controller: self, pushVC: ManageViewController(), title: "", message: "RefuseworkAlert".localize, completion: {
                apiClient.postReserve(url: APIPaths().taskdenyRequest(), method: .post, parameters: parameter, header: header) { (json, string) in
                }
                let mana = ManageViewController(nibName: NibManageViewController, bundle: nil)
                self.navigationController?.pushViewController(mana, animated: true)
            })
        }else{
            let parameter = ["id":processPending!.id!]
            let header = ["hbbgvauth":"\(UserDefaultHelper.getToken()!)"]
            let apiClient = APIService.shared
            let alertC = AlertStandard.sharedInstance
            alertC.showAlertCt(controller: self, pushVC: nil, title: "", message: "cancelWork".localize, completion: {
                apiClient.deleteReserve(url: APIPaths().urlCancelTask(), method: .delete, parameters: parameter, header: header) { (json, string) in
                }
                let mana = ManageViewController(nibName: NibManageViewController, bundle: nil)
                self.navigationController?.pushViewController(mana, animated: true)
            })
        }
 
        tbPending.reloadData()
    }
}
extension PendingController:directRequestDelegate{
    func chooseActionRequest() {
        let alertC = AlertStandard.sharedInstance
        alertC.showAlertCt(controller: self, pushVC: nil, title: "", message: "Dothiswork".localize) {
            self.loadingView.show()
            guard let ownerId = self.processPending?.stakeholders?.owner?.id else {return}
            guard let taskID = self.processPending?.id else {return}
            guard let token = UserDefaultHelper.getToken() else{return}
            let parameter = ["id":taskID,"ownerId":"\(ownerId)"]
            let header = ["Content-Type":"application/x-www-form-urlencoded","hbbgvauth":token]
            let apiClient = APIService.shared
            apiClient.postReserve(url: APIPaths().urlTaskAcceptRequest(), method: .post, parameters: parameter, header: header) { (json, string) in
                self.loadingView.close()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
//extension PendingController:denyRequestDelegate{
//    func denyRequest() {
//        MBProgressHUD.showAdded(to: self.view, animated: true)
//        guard let ownerId = processPending?.stakeholders?.owner?.id else {return}
//        guard let taskID = processPending?.id else {return}
//        let parameter = ["id":taskID,"ownerId":"\(ownerId)"]
//        let header = ["Content-Type":"application/x-www-form-urlencoded","hbbgvauth":"\(UserDefaultHelper.getToken()!)"]
//        let apiClient = APIService.shared
//            let alertC = AlertStandard.sharedInstance
//            MBProgressHUD.hide(for: self.view, animated: true)
//            alertC.showAlertCt(controller: self, pushVC: ManageViewController(), title: "", message: "RefuseworkAlert".localize, completion: {
//                 apiClient.postReserve(url: APIPaths().taskdenyRequest(), method: .post, parameters: parameter, header: header) { (json, string) in
//            }
//        })
//  }
//}

