//
//  ManageViewController.swift
//  GV24
//
//  Created by HuyNguyen on 6/1/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class ManageViewController: BaseViewController {
    @IBOutlet weak var segmentCtr: UISegmentedControl!
    @IBOutlet weak var tbManage: UITableView!
    var idProcess:String?
    var processOnCreate = [Work]()
    var processPending = [Work]()
    var processDone = [Work]()
    var processOnDoing = [Work]()
    var processRecieved = [Work]()
    var returnValue:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        tbManage.register(UINib(nibName:"HistoryViewCell",bundle:nil), forCellReuseIdentifier: "historyCell")
        getProcess()
        
    }
    override func decorate() {
        super.decorate()
        segmentCtr.backgroundColor = UIColor.white
        segmentCtr.tintColor = UIColor.colorWithRedValue(redValue: 61, greenValue: 197, blueValue: 204, alpha: 1)
    }
    override func setupViewBase() {
        super.setupViewBase()
        self.title = "Taskmanagement".localize
    }
    
    @IBAction func segmentControlAction(_ sender: Any) {
        let sortedViews = (sender as AnyObject).subviews.sorted( by: { $0.frame.origin.x < $1.frame.origin.x } )
        for (index, view) in sortedViews.enumerated() {
            if index == (sender as AnyObject).selectedSegmentIndex {
                view.tintColor = UIColor.colorWithRedValue(redValue: 61, greenValue: 197, blueValue: 204, alpha: 1)
            } else {
                view.tintColor = UIColor.colorWithRedValue(redValue: 61, greenValue: 197, blueValue: 204, alpha: 1)
            }
        }
        tbManage.reloadData()
    }
    func getProcess() {
        let parameterCreate = ["process":"\(WorkStatus.OnCreate.rawValue)"]
        let parmaterPending = ["process":"\(WorkStatus.Pending.rawValue)"]
        let parmaterOnDoing = ["process":"\(WorkStatus.OnDoing.rawValue)"]
        let parmaterRecieve = ["process":"\(WorkStatus.Recieved.rawValue)"]
        let header = ["hbbgvauth":"\(UserDefaultHelper.getToken()!)"]
        let apiService = AroundTask.sharedInstall
        apiService.getProcessID(url: APIPaths().urlPocess(), parameter: parameterCreate, header: header) { (json, error) in
            if json != nil{
                self.processOnCreate = json!
            }
            self.tbManage.reloadData()
            }
        apiService.getProcessID(url: APIPaths().urlPocess(), parameter: parmaterPending, header: header) { (json, error) in
            if json != nil{
                self.processPending = json!
            }
            self.tbManage.reloadData()
            }
        apiService.getProcessID(url: APIPaths().urlPocess(), parameter: parmaterRecieve, header: header) { (json, error) in
            if json != nil{
                self.processRecieved = json!
            }
            self.tbManage.reloadData()
            }
        apiService.getProcessID(url: APIPaths().urlPocess(), parameter: parmaterOnDoing, header: header) { (json, error) in
            if json != nil{
                self.processOnDoing = json!
            }
            self.tbManage.reloadData()
            }
        }
}
extension ManageViewController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentCtr.selectedSegmentIndex {
        case 0:
            returnValue = processOnCreate.count
        case 1:
            returnValue = processRecieved.count
        case 2:
            returnValue = processOnDoing.count
            break
        default:
            break
        }
        return returnValue
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbManage.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as? HistoryViewCell
        switch segmentCtr.selectedSegmentIndex {
        case 0:
            cell?.workNameLabel.text = processOnCreate[indexPath.row].info?.title
            cell?.createdDate.text = "\(Date(isoDateString: (processOnCreate[indexPath.row].history?.createAt)!).dayMonthYear)"
            cell?.timeWork.text = "\(Date(isoDateString: (processOnCreate[indexPath.row].workTime?.startAt)!).hourMinute)\(" - ")\(Date(isoDateString: (processOnCreate[indexPath.row].workTime?.endAt)!).hourMinute)"
            cell?.lbDist.text = processOnCreate[indexPath.row].process?.name
            cell?.lbTimePost.text = Date().dateFormat(datePost: (processOnCreate[indexPath.row].history?.createAt)!)
            UserDefaultHelper.setUserOwner(user: processOnCreate[indexPath.row].stakeholders?.owner)
        case 1:
            cell?.workNameLabel.text = processRecieved[indexPath.row].info?.title
            cell?.createdDate.text = "\(Date(isoDateString: (processRecieved[indexPath.row].history?.createAt)!).dayMonthYear)"
            cell?.lbTimePost.text = Date().dateFormat(datePost: (processRecieved[indexPath.row].history?.createAt)!)
            cell?.timeWork.text = "\(Date(isoDateString: (processRecieved[indexPath.row].workTime?.startAt)!).hourMinute)\(" - ")\(Date(isoDateString: (processRecieved[indexPath.row].workTime?.endAt)!).hourMinute)"
            cell?.lbDist.text = processRecieved[indexPath.row].process?.name
        case 2:
            cell?.workNameLabel.text = processOnDoing[indexPath.row].info?.title
            cell?.createdDate.text = "\(Date(isoDateString: (processOnDoing[indexPath.row].history?.createAt)!).dayMonthYear)"
            cell?.lbTimePost.text = Date().dateFormat(datePost: (processOnDoing[indexPath.row].history?.createAt)!)
            cell?.timeWork.text = "\(Date(isoDateString: (processOnDoing[indexPath.row].workTime?.startAt)!).hourMinute)\(" - ")\(Date(isoDateString: (processOnDoing[indexPath.row].workTime?.endAt)!).hourMinute)"
            cell?.lbDist.text = processOnDoing[indexPath.row].process?.name
        default:
            break
        }
        return cell!
    }
}
extension ManageViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch segmentCtr.selectedSegmentIndex {
        case 0:
            let navi = PendingController(nibName: "PendingController", bundle: nil)
                navi.processPending = processOnCreate[indexPath.row]
                navigationController?.pushViewController(navi, animated: true)
            break
        case 1:
            let navi = RecievedController(nibName: "RecievedController", bundle: nil)
            navi.processRecieved = processRecieved[indexPath.row]
            navigationController?.pushViewController(navi, animated: true)
            break
        case 2:
            let navi = DoingController(nibName: "DoingController", bundle: nil)
            navi.ProcessDoing = processOnDoing[indexPath.row]
            navigationController?.pushViewController(navi, animated: true)
            break
        default:
            break
        }
    }
}

