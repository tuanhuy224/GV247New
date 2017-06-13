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
        tbRecieved.register(UINib(nibName:"WorkDetailCell",bundle:nil), forCellReuseIdentifier: "workDetailCell")
        tbRecieved.register(UINib(nibName:"InfoDetailCell",bundle:nil), forCellReuseIdentifier: "infoDetailCell")
        tbRecieved.register(UINib(nibName:"WaittingCell",bundle:nil), forCellReuseIdentifier: "waittingCell")
        tbRecieved.allowsSelection = false
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
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            let cell:WorkDetailCell = tbRecieved.dequeueReusableCell(withIdentifier: "workDetailCell", for: indexPath) as! WorkDetailCell
            cell.nameUser.text = processRecieved?.stakeholders?.owner?.name
            cell.addressName.text = processRecieved?.stakeholders?.owner?.address?.name
            let url = URL(string: (processRecieved?.stakeholders?.owner?.image)!)
            cell.imageName.kf.setImage(with: url)
            return cell
        case 1:
            let cell:InfoDetailCell = tbRecieved.dequeueReusableCell(withIdentifier: "infoDetailCell", for: indexPath) as! InfoDetailCell
            cell.lbTitle.text = processRecieved?.info?.title
            cell.lbSubTitle.text = processRecieved?.info?.address?.name
            cell.lbComment.text = processRecieved?.info?.content
            cell.lbDate.text = "\(Date(isoDateString: (processRecieved?.workTime?.startAt)!).dayMonthYear) \(" - ") \(Date(isoDateString: (processRecieved?.workTime?.endAt)!).dayMonthYear)"
            cell.lbMoney.text = "\(processRecieved?.info?.salary ?? 0) $"
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
            return 80
        default:
            return 284
        }
    }
    
}
