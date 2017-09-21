//
//  WaittingController.swift
//  GV24
//
//  Created by HuyNguyen on 9/21/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class WaittingController: BaseViewController {
    @IBOutlet weak var tbWaitting: UITableView!

    var arrayWaitting: [Work]? {
        didSet{
            tbWaitting.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbWaitting.on_register(type: DeadlineCell.self)
        tbWaitting.on_register(type: DirectCell.self)
        tbWaitting.on_register(type: NormalCell.self)
        tbWaitting.rowHeight = UITableViewAutomaticDimension
        tbWaitting.estimatedRowHeight = 100
        tbWaitting.separatorStyle = .none
    }
    
    override func getDataForScreen() {
        super.getDataForScreen()
        
        guard let token = UserDefaultHelper.getToken() else{return}
        let parameterCreate = ["process":"\(WorkStatus.OnCreate.rawValue)"]
        let header = ["hbbgvauth":token]
        let apiService = AroundTask.sharedInstall
        loadingView.show()
        apiService.getProcessID(url: APIPaths().urlPocess(), parameter: parameterCreate, header: header) { (json, error) in
            self.loadingView.close()
            guard let jsonData = json else {return}
            self.arrayWaitting = jsonData
        }
    }


}

extension WaittingController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayWaitting?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if arrayWaitting?[indexPath.row].process?.id == WorkStatus.Direct.rawValue && Date(isoDateString: (arrayWaitting?[indexPath.row].workTime?.endAt)!).comparse == true || Date(isoDateString: (arrayWaitting?[indexPath.row].workTime?.endAt)!).comparse == true {
            let cell: DeadlineCell = tbWaitting.on_dequeue(idxPath: indexPath)
            cell.proccessPending = arrayWaitting?[indexPath.row]
            return cell
        }else if arrayWaitting?[indexPath.row].process?.id == WorkStatus.OnCreate.rawValue{
            let cell: NormalCell = tbWaitting.on_dequeue(idxPath: indexPath)
            cell.proccessPending = arrayWaitting?[indexPath.row]
            return cell
        }else{
            let cell: DirectCell = tbWaitting.on_dequeue(idxPath: indexPath)
            cell.proccessPending = arrayWaitting?[indexPath.row]
            return cell
        }
    }
}

extension WaittingController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let navi = PendingController()
        navi.processPending = arrayWaitting?[indexPath.row]
        navigationController?.pushViewController(navi, animated: true)
    }
}

