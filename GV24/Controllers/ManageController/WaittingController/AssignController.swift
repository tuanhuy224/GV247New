//
//  AssignController.swift
//  GV24
//
//  Created by HuyNguyen on 9/21/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class AssignController: BaseViewController {
    @IBOutlet weak var tbAssign: UITableView!

    
    var arrayAssign: [Work]? {
        didSet{
            tbAssign.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbAssign.on_register(type: DeadlineCell.self)
        tbAssign.on_register(type: DirectCell.self)
        tbAssign.on_register(type: NormalCell.self)
        tbAssign.rowHeight = UITableViewAutomaticDimension
        tbAssign.estimatedRowHeight = 100
        tbAssign.separatorStyle = .none
    }
    
    override func getDataForScreen() {
        super.getDataForScreen()
        
        guard let token = UserDefaultHelper.getToken() else{return}
        let parmaterRecieve = ["process":"\(WorkStatus.Recieved.rawValue)"]
        let header = ["hbbgvauth":token]
        let apiService = AroundTask.sharedInstall
        loadingView.show()
        
        apiService.getProcessID(url: APIPaths().urlPocess(), parameter: parmaterRecieve, header: header) { (json, error) in
            self.loadingView.close()
            guard let jsonData = json else {return}
            self.arrayAssign = jsonData
        }
    }


}

extension AssignController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayAssign?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if arrayAssign?[indexPath.row].process?.id == WorkStatus.Direct.rawValue && Date(isoDateString: (arrayAssign?[indexPath.row].workTime?.endAt)!).comparse == true || Date(isoDateString: (arrayAssign?[indexPath.row].workTime?.endAt)!).comparse == true {
            let cell: DeadlineCell = tbAssign.on_dequeue(idxPath: indexPath)
            cell.proccessPending = arrayAssign?[indexPath.row]
            return cell
        }else if arrayAssign?[indexPath.row].process?.id == WorkStatus.OnCreate.rawValue{
                let cell: NormalCell = tbAssign.on_dequeue(idxPath: indexPath)
                cell.proccessPending = arrayAssign?[indexPath.row]
                return cell
        }else{
            let cell: DirectCell = tbAssign.on_dequeue(idxPath: indexPath)
            cell.proccessPending = arrayAssign?[indexPath.row]
            return cell
        }
    }
}

extension AssignController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let navi = RecievedController()
        navi.processRecieved = arrayAssign?[indexPath.row]
        navigationController?.pushViewController(navi, animated: true)
    }
}
