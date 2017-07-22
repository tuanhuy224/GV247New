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
    var longGesture = UILongPressGestureRecognizer()
    override func viewDidLoad() {
        super.viewDidLoad()
        tbManage.on_register(type: HistoryViewCell.self)
        tbManage.separatorStyle = .none
        self.title = "Titlemanagement".localize
        self.tbManage.rowHeight = UITableViewAutomaticDimension
        self.tbManage.estimatedRowHeight = 100.0

    }
    override func decorate() {
        super.decorate()
        segmentCtr.backgroundColor = UIColor.white
        segmentCtr.tintColor = UIColor.colorWithRedValue(redValue: 61, greenValue: 197, blueValue: 204, alpha: 1)
    }
    override func setupViewBase() {
        super.setupViewBase()
        segmentCtr.setTitle("waiting".localize, forSegmentAt: 0)
        segmentCtr.setTitle("assigned".localize, forSegmentAt: 1)
        segmentCtr.setTitle("runnning".localize, forSegmentAt: 2)
        getProcess()
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
        loadingView.show()
        apiService.getProcessID(url: APIPaths().urlPocess(), parameter: parameterCreate, header: header) { (json, error) in
            self.loadingView.close()
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
            self.loadingView.close()
            if json != nil{
                self.processRecieved = json!
            }
            self.tbManage.reloadData()
        }
        apiService.getProcessID(url: APIPaths().urlPocess(), parameter: parmaterOnDoing, header: header) { (json, error) in
            self.loadingView.close()
            if json != nil{
                self.processOnDoing = json!
            }
        }
        self.tbManage.reloadData()
    }
    
    fileprivate func configurationCell(cell:UITableViewCell){
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
        let cell:HistoryViewCell = tbManage.on_dequeue(idxPath: indexPath)
        switch segmentCtr.selectedSegmentIndex {
        case 0:
            if processOnCreate[indexPath.row].process?.id == WorkStatus.Direct.rawValue  && Date() > String.convertISODateToDate(isoDateStr: (processOnCreate[indexPath.row].workTime?.endAt)!)! {
                cell.lbDirect.isHidden = true
                cell.lbDeadline.isHidden = false
                cell.lbDeadline.text = "Expired".localize
            }else if Date() > String.convertISODateToDate(isoDateStr: (processOnCreate[indexPath.row].workTime?.endAt)!)!{
                cell.lbDirect.isHidden = true
                cell.lbDeadline.isHidden = false
                cell.lbDeadline.text = "Expired".localize
            }else{
                cell.lbDirect.isHidden = false
                cell.lbDeadline.isHidden = true
                cell.lbDirect.text = "Direct".localize
            }
            cell.workNameLabel.text = processOnCreate[indexPath.row].info?.title
            cell.createdDate.text = "\(Date(isoDateString: (processOnCreate[indexPath.row].workTime?.startAt)!).dayMonthYear)"
            cell.timeWork.text = "\(Date(isoDateString: (processOnCreate[indexPath.row].workTime?.startAt)!).hourMinute)\(" - ")\(Date(isoDateString: (processOnCreate[indexPath.row].workTime?.endAt)!).hourMinute)"
            cell.lbDist.text = "Proccess".localize
            cell.lbTimePost.text = "\(Date().dateComPonent(datePost: (processOnCreate[indexPath.row].history?.createAt)!))"
            UserDefaultHelper.setUserOwner(user: processOnCreate[indexPath.row].stakeholders?.owner)
            cell.timeWork.text = String.convertISODateToString(isoDateStr: (processOnCreate[indexPath.row].workTime?.startAt)!, format: "HH:mm a")! + " - " + String.convertISODateToString(isoDateStr: (processOnCreate[indexPath.row].workTime?.endAt)!, format: "HH:mm a")!
            
        case 1:
            cell.workNameLabel.text = processRecieved[indexPath.row].info?.title
            cell.createdDate.text = "\(Date(isoDateString: (processRecieved[indexPath.row].workTime?.startAt)!).dayMonthYear)"
            cell.lbTimePost.text = "\(Date().dateComPonent(datePost: (processRecieved[indexPath.row].history?.createAt)!))"
            cell.timeWork.text = "\(Date(isoDateString: (processRecieved[indexPath.row].workTime?.startAt)!).hourMinute)\(" - ")\(Date(isoDateString: (processRecieved[indexPath.row].workTime?.endAt)!).hourMinute)"
            cell.lbDist.text = processRecieved[indexPath.row].process?.name?.localize
            if processRecieved[indexPath.row].process?.id == WorkStatus.Direct.rawValue  && Date() > String.convertISODateToDate(isoDateStr: (processRecieved[indexPath.row].workTime?.endAt)!)! {
              cell.lbDirect.isHidden = true
              cell.lbDeadline.isHidden = false
              cell.lbDeadline.text = "Expired".localize
            }else if Date() > String.convertISODateToDate(isoDateStr: (processRecieved[indexPath.row].workTime?.endAt)!)!{
              cell.lbDirect.isHidden = true
              cell.lbDeadline.isHidden = false
              cell.lbDeadline.text = "Expired".localize
            }
            cell.lbDirect.isHidden = true
            cell.constraintWidthDirect.constant = 0
        case 2:
            cell.workNameLabel.text = processOnDoing[indexPath.row].info?.title
            cell.createdDate.text = "\(Date(isoDateString: (processOnDoing[indexPath.row].workTime?.startAt)!).dayMonthYear)"
            cell.lbTimePost.text = "\(Date().dateComPonent(datePost: (processOnDoing[indexPath.row].history?.createAt)!))"
            cell.timeWork.text = "\(Date(isoDateString: (processOnDoing[indexPath.row].workTime?.startAt)!).hourMinute)\(" - ")\(Date(isoDateString: (processOnDoing[indexPath.row].workTime?.endAt)!).hourMinute)"
                cell.lbDist.text = "OnDoing".localize
            cell.lbDeadline.isHidden = true
            cell.timeWork.text = String.convertISODateToString(isoDateStr: (processOnDoing[indexPath.row].workTime?.startAt)!, format: "HH:mm a")! + " - " + String.convertISODateToString(isoDateStr: (processOnDoing[indexPath.row].workTime?.endAt)!, format: "HH:mm a")!
            cell.lbDirect.isHidden = true
            cell.constraintWidthDirect.constant = 0
        default:
            break
        }
            var directWidth:CGFloat = 0
            var deadlineWitdh:CGFloat = 0
            
            if !cell.lbDirect.isHidden {
                let text = cell.lbDirect.text ?? ""
                let height = cell.lbDirect.bounds.height
                let font = cell.lbDirect.font!
                directWidth = text.width(withConstraintedHeight: height, font: font)
                directWidth = ceil(directWidth) + 20
            }
            if !cell.lbDeadline.isHidden {
                let text = cell.lbDeadline.text ?? ""
                let height = cell.lbDeadline.bounds.height
                let font = cell.lbDeadline.font!
                deadlineWitdh = text.width(withConstraintedHeight: height, font: font)
                deadlineWitdh = ceil(deadlineWitdh) + 20
            }
            cell.constraintWidthDirect.constant =  directWidth
            cell.contraintWidthDeadline.constant = deadlineWitdh
        return cell
    }
}
extension ManageViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch segmentCtr.selectedSegmentIndex {
        case 0:
            let navi = PendingController(nibName: CTPendingController, bundle: nil)
            navi.processPending = processOnCreate[indexPath.row]
            navigationController?.pushViewController(navi, animated: true)
            break
        case 1:
            let navi = RecievedController(nibName: CTRecievedController, bundle: nil)
            navi.processRecieved = processRecieved[indexPath.row]
            navigationController?.pushViewController(navi, animated: true)
            break
        case 2:
            let navi = DoingController(nibName: CTDoingController, bundle: nil)
            navi.ProcessDoing = processOnDoing[indexPath.row]
            navigationController?.pushViewController(navi, animated: true)
            break
        default:
            break
        }
    }
}

