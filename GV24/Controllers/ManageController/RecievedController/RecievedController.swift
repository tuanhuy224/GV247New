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
    var lable:UILabel?
    
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
            cell.work = processRecieved
            cell.delegate = self
            return cell
        case 1:
            let cell:InfoDetailCell = tbRecieved.dequeueReusableCell(withIdentifier: infoDetailCellID, for: indexPath) as! InfoDetailCell
            cell.work = processRecieved
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
            let navi = DetailManagementController()
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
        guard let id = processRecieved?.id else {return}
        guard let token = UserDefaultHelper.getToken() else {return}
        let parameter = ["id":id]
        let header = ["hbbgvauth": token]
        let apiClient = APIService.shared
        let alertC = AlertStandard.sharedInstance
        alertC.showAlertCt(controller: self, pushVC: PageViewController(), title: "", message: "RefuseworkAlert".localize, completion: {
            self.loadingView.show()
            apiClient.deleteReserve(url: APIPaths().urlCancelTask(), method: .delete, parameters: parameter, header: header) { (json, string) in
                self.loadingView.close()
            }
            let mana = PageViewController()
            self.navigationController?.pushViewController(mana, animated: true)
        })
    }
}
extension RecievedController:chooseWorkDelegate{
    func detailManagementDelegate() {
        let navi = DetailManagementController()
        navi.workPending = processRecieved
        navigationController?.pushViewController(navi, animated: true)
    }
}
