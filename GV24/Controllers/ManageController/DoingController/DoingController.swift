//
//  DoingController.swift
//  GV24
//
//  Created by HuyNguyen on 6/13/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Kingfisher

class DoingController: BaseViewController {
    @IBOutlet weak var tbDoing: UITableView!
    var ProcessDoing:Work?
    override func viewDidLoad() {
        super.viewDidLoad()
        tbDoing.register(UINib(nibName:NibWorkDetailCell,bundle:nil), forCellReuseIdentifier: workDetailCellID)
        tbDoing.register(UINib(nibName:NibInfoDetailCell,bundle:nil), forCellReuseIdentifier: infoDetailCellID)
        tbDoing.register(UINib(nibName:NibCancelCell,bundle:nil), forCellReuseIdentifier: cancelCellID)
        tbDoing.separatorStyle = .none
        self.tbDoing.rowHeight = UITableViewAutomaticDimension
        self.tbDoing.estimatedRowHeight = 100.0
    }
    override func setupViewBase() {
        super.setupViewBase()
        self.title = "\(ProcessDoing?.info?.title ?? "")".localize
    }
}
extension DoingController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            let cell:WorkDetailCell = tbDoing.dequeueReusableCell(withIdentifier: workDetailCellID, for: indexPath) as! WorkDetailCell
            if ProcessDoing?.process?.id == WorkStatus.Direct.rawValue {
                cell.btChoose.isHidden = false
                cell.vSegment.isHidden = false
            }else{
                cell.btChoose.isEnabled = true
                cell.heightBtChoose.constant = 0
            }
            cell.nameUser.text = ProcessDoing?.stakeholders?.owner?.name
            cell.addressName.text = ProcessDoing?.stakeholders?.owner?.address?.name
            let url = URL(string: (ProcessDoing?.stakeholders?.owner?.image)!)
            if url == nil {
                DispatchQueue.main.async {
                    cell.imageName.image = UIImage(named: "avatar")
                }
            }else{
                DispatchQueue.main.async {
                    cell.imageName.kf.setImage(with: url)
                }
            }
            cell.delegate = self
            return cell
        case 1:
            let cell:InfoDetailCell = tbDoing.dequeueReusableCell(withIdentifier: infoDetailCellID, for: indexPath) as! InfoDetailCell
            cell.lbDescription.text = "Description".localize
            cell.lbTitle.text = ProcessDoing?.info?.title
            cell.lbSubTitle.text = ProcessDoing?.info?.address?.name
            cell.lbComment.text = ProcessDoing?.info?.content
            cell.lbDate.text = "\(Date(isoDateString: (ProcessDoing?.workTime?.startAt)!).dayMonthYear) \(" - ") \(Date(isoDateString: (ProcessDoing?.workTime?.endAt)!).dayMonthYear)"
            cell.lbMoney.text = "\(ProcessDoing?.info?.salary ?? 0) $"
            cell.lbTime.text = String.convertISODateToString(isoDateStr: (self.ProcessDoing?.workTime!.startAt)!, format: "HH:mm a")! + " - " + String.convertISODateToString(isoDateStr: (self.ProcessDoing?.workTime!.endAt)!, format: "HH:mm a")!
            cell.lbAddress.text = ProcessDoing?.stakeholders?.owner?.address?.name
            return cell
        case 2:
            let cell:CancelCell = tbDoing.dequeueReusableCell(withIdentifier: cancelCellID, for: indexPath) as! CancelCell
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
}
extension DoingController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let navi = DetailManagementController(nibName: "DetailManagementController", bundle: nil)
            navi.workPending = ProcessDoing
            navigationController?.pushViewController(navi, animated: true)
            break
        default:
            break
        }
    }
}

extension DoingController:chooseWorkDelegate{
    func detailManagementDelegate() {
        let navi = DetailManagementController(nibName: "DetailManagementController", bundle: nil)
        navi.workPending = ProcessDoing
        navigationController?.pushViewController(navi, animated: true)
    }
}
