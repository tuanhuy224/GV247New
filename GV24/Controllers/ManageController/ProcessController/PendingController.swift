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
    @IBOutlet weak var btSelect: UIButton!
    var processPending: Work?
    var isChoose: Bool = false
    var constraint: NSLayoutConstraint?
    override func viewDidLoad() {
        super.viewDidLoad()
        tbPending.register(UINib(nibName:NibWorkDetailCell,bundle:nil), forCellReuseIdentifier: workDetailCellID)
        tbPending.register(UINib(nibName:NibInfoDetailCell,bundle:nil), forCellReuseIdentifier: infoDetailCellID)
        tbPending.register(UINib(nibName:NibCancelCell,bundle:nil), forCellReuseIdentifier: cancelCellID)

        tbPending.separatorStyle = .none
        self.tbPending.rowHeight = UITableViewAutomaticDimension
        self.tbPending.estimatedRowHeight = 100.0
        
    }

    @IBAction func btSelectAction(_ sender: Any) {
        chooseActionRequest()
    }
    
    // MARK: - select application
    func chooseActionRequest() {
        let alertC = AlertStandard.sharedInstance
        if isChoose == true {
            AlertStandard.sharedInstance.showAlert(controller: self, title: "", message: "Workyouchooseisexpired".localize)
        }else{
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
                    if string == "SCHEDULE_DUPLICATED"{
                        AlertStandard.sharedInstance.showAlert(controller: self, title: "", message: "Workcurrentlychosen".localize)
                    }
                    AlertStandard.sharedInstance.showAlert(controller: self, title: "", message: "Workchosensuccessfully".localize)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.title = "waiting".localize
        btSelect.isHidden = true
        UIButton.cornerButton(bt: btSelect, radius: 8)
        btSelect.backgroundColor = AppColor.backButton
        if processPending?.process?.id == WorkStatus.Direct.rawValue && Date(isoDateString: (processPending?.workTime?.endAt)!).comparse == false {
            btSelect.isHidden = false
            btSelect.setTitle("Selectthiswork".localize, for: .normal)
            btSelect.setTitleColor(AppColor.white, for: .normal)
        }
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
            cell.work = processPending

            return cell
        case 1:
            let cell:InfoDetailCell = tbPending.dequeueReusableCell(withIdentifier: infoDetailCellID, for: indexPath) as! InfoDetailCell
            cell.work = processPending
            if Date(isoDateString: (processPending?.workTime?.endAt)!).comparse == true {
                cell.lbdeadLine.isHidden = false
                cell.lbdeadLine.text = "Expired".localize
            }else{
                cell.lbdeadLine.isHidden = true
            }
            var deadlineWitdh:CGFloat = 0
            if !cell.lbdeadLine.isHidden {
                let text = cell.lbdeadLine.text ?? ""
                let height = cell.lbdeadLine.bounds.height
                let font = cell.lbdeadLine.font!
                deadlineWitdh = text.width(withConstraintedHeight: height, font: font)
                deadlineWitdh = ceil(deadlineWitdh) + 20
            }
            cell.contraintWidthDeadline.constant = deadlineWitdh
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
                self.navigationController?.popViewController(animated: true)
            })
        }
        
        tbPending.reloadData()
    }
}


