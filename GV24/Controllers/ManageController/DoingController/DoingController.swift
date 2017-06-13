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

        tbDoing.register(UINib(nibName:"WorkDetailCell",bundle:nil), forCellReuseIdentifier: "workDetailCell")
        tbDoing.register(UINib(nibName:"InfoDetailCell",bundle:nil), forCellReuseIdentifier: "infoDetailCell")
        tbDoing.register(UINib(nibName:"WaittingCell",bundle:nil), forCellReuseIdentifier: "waittingCell")
        tbDoing.allowsSelection = false
    }
    override func setupViewBase() {
        super.setupViewBase()
        self.title = "\(ProcessDoing?.info?.title ?? "")".localize
        self.navigationController?.navigationBar.topItem?.title = ""
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
            let cell:WorkDetailCell = tbDoing.dequeueReusableCell(withIdentifier: "workDetailCell", for: indexPath) as! WorkDetailCell
            cell.nameUser.text = ProcessDoing?.stakeholders?.owner?.name
            cell.addressName.text = ProcessDoing?.stakeholders?.owner?.address?.name
            let url = URL(string: (ProcessDoing?.stakeholders?.owner?.image)!)
            cell.imageName.kf.setImage(with: url)
            return cell
        case 1:
            let cell:InfoDetailCell = tbDoing.dequeueReusableCell(withIdentifier: "infoDetailCell", for: indexPath) as! InfoDetailCell
            cell.lbTitle.text = ProcessDoing?.info?.title
            cell.lbSubTitle.text = ProcessDoing?.info?.address?.name
            cell.lbComment.text = ProcessDoing?.info?.content
            cell.lbDate.text = "\(Date(isoDateString: (ProcessDoing?.workTime?.startAt)!).dayMonthYear) \(" - ") \(Date(isoDateString: (ProcessDoing?.workTime?.endAt)!).dayMonthYear)"
            cell.lbMoney.text = "\(ProcessDoing?.info?.salary ?? 0) $"
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
}
extension DoingController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 80
        default:
            return 284
        }
    }
    
}
