//
//  RunningController.swift
//  GV24
//
//  Created by HuyNguyen on 9/21/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class RunningController: BaseViewController {
    @IBOutlet weak var tbRunning: UITableView!
    var arrayDoing = [Work]() {
        didSet{
            tbRunning.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbRunning.register(UINib(nibName:NibWorkDetailCell,bundle:nil), forCellReuseIdentifier: workDetailCellID)
        tbRunning.register(UINib(nibName:NibInfoDetailCell,bundle:nil), forCellReuseIdentifier: infoDetailCellID)
        tbRunning.rowHeight = UITableViewAutomaticDimension
        tbRunning.estimatedRowHeight = 100
        tbRunning.separatorStyle = .none
    }
    
    override func getDataForScreen() {
        super.getDataForScreen()
        guard let token = UserDefaultHelper.getToken() else{return}
        let parmaterOnDoing = ["process":"\(WorkStatus.OnDoing.rawValue)"]
        let header = ["hbbgvauth":token]
        let apiService = AroundTask.sharedInstall
        loadingView.show()
        apiService.getProcessID(url: APIPaths().urlPocess(), parameter: parmaterOnDoing, header: header) { (json, error) in
            self.loadingView.close()
            guard let jsonData = json else {return}
            self.arrayDoing = jsonData
            
        }
    }
    
}
extension RunningController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell: WorkDetailCell = tbRunning.dequeueReusableCell(withIdentifier: workDetailCellID, for: indexPath) as! WorkDetailCell
            if arrayDoing == [] {
                cell.backgroundColor = .groupTableViewBackground
                cell.isHidden = true
            }else{
                cell.work = arrayDoing[indexPath.row]
            }
            return cell
        case 1:
            let cell: InfoDetailCell = tbRunning.dequeueReusableCell(withIdentifier: infoDetailCellID, for: indexPath) as! InfoDetailCell
            
            if arrayDoing == [] {
                cell.backgroundColor = .groupTableViewBackground
                cell.isHidden = true
            }else{
                
                cell.work = arrayDoing[indexPath.row]
            }
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
}

extension RunningController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let navi = DetailManagementController()
        navi.workPending = arrayDoing[indexPath.row]
        navigationController?.pushViewController(navi, animated: true)
    }
}
