//
//  ManageViewController.swift
//  GV24
//
//  Created by HuyNguyen on 6/1/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class ManageViewController: BaseViewController {
    @IBOutlet weak var vDoing: UIView!
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
    override func viewDidLoad(){
        super.viewDidLoad()
        tbManage.on_register(type: HistoryViewCell.self)
        tbManage.register(UINib(nibName:NibWorkDetailCell,bundle:nil), forCellReuseIdentifier: workDetailCellID)
        tbManage.register(UINib(nibName:NibInfoDetailCell,bundle:nil), forCellReuseIdentifier: infoDetailCellID)
        tbManage.separatorStyle = .none
        self.title = "Titlemanagement".localize
        self.tbManage.rowHeight = UITableViewAutomaticDimension
        self.tbManage.estimatedRowHeight = 100.0
        vDoing.isHidden = true
        getProcess()
    }
    override func decorate() {
        super.decorate()
        segmentCtr.backgroundColor = UIColor.white
        segmentCtr.tintColor = AppColor.backButton
    }
    override func setupViewBase() {
        super.setupViewBase()
        segmentCtr.setTitle("waiting".localize, forSegmentAt: 0)
        segmentCtr.setTitle("assigned".localize, forSegmentAt: 1)
        segmentCtr.setTitle("runnning".localize, forSegmentAt: 2)
        tbManage.reloadData()
        if processOnDoing == [] {
            return
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    @IBAction func segmentControlAction(_ sender: Any) {
        let sortedViews = (sender as AnyObject).subviews.sorted( by: { $0.frame.origin.x < $1.frame.origin.x } )
        for (index, view) in sortedViews.enumerated() {
            if index == (sender as AnyObject).selectedSegmentIndex {
                view.tintColor = AppColor.backButton
            } else {
                view.tintColor = AppColor.backButton
            }
        }
        tbManage.reloadData()
    }
    func getProcess() {
        guard let token = UserDefaultHelper.getToken() else{return}
        let parameterCreate = ["process":"\(WorkStatus.OnCreate.rawValue)"]
        let parmaterOnDoing = ["process":"\(WorkStatus.OnDoing.rawValue)"]
        let parmaterRecieve = ["process":"\(WorkStatus.Recieved.rawValue)"]
        let header = ["hbbgvauth":token]
        let apiService = AroundTask.sharedInstall
        loadingView.show()
        apiService.getProcessID(url: APIPaths().urlPocess(), parameter: parameterCreate, header: header) { (json, error) in
            self.loadingView.close()
            DispatchQueue.global(qos: .userInitiated).async {
                if json != nil{
                    self.processOnCreate = json!
                }
                DispatchQueue.main.async {
                    self.tbManage.reloadData()
                    
                }
            }
        }
        apiService.getProcessID(url: APIPaths().urlPocess(), parameter: parmaterRecieve, header: header) { (json, error) in
            self.loadingView.close()
            DispatchQueue.global(qos: .userInitiated).async {
                if json != nil{
                    self.processRecieved = json!
                }
                DispatchQueue.main.async {
                    self.tbManage.reloadData()
                    
                }
            }
        }
        apiService.getProcessID(url: APIPaths().urlPocess(), parameter: parmaterOnDoing, header: header) { (json, error) in
            self.loadingView.close()
            DispatchQueue.global(qos: .userInitiated).async {
                if json != nil{
                    self.processOnDoing = json!
                }
                DispatchQueue.main.async {
                    self.tbManage.reloadData()
                    
                }
            }
        }
        self.tbManage.reloadData()
    }
    
    fileprivate func configurationCell(cell:HistoryViewCell){
    }
    
    
}
extension ManageViewController:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch segmentCtr.selectedSegmentIndex {
        case 2:
            return 2
        default:
            return 1
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentCtr.selectedSegmentIndex {
        case 0:
            returnValue = processOnCreate.count
        case 1:
            returnValue = processRecieved.count
            break
        case 2:
            return 1
        default:
            break
        }
        return returnValue
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:HistoryViewCell = tbManage.on_dequeue(idxPath: indexPath)
        let cell1:WorkDetailCell = tbManage.dequeueReusableCell(withIdentifier: workDetailCellID, for: indexPath) as! WorkDetailCell
        let cell2:InfoDetailCell = tbManage.dequeueReusableCell(withIdentifier: infoDetailCellID, for: indexPath) as! InfoDetailCell
        switch segmentCtr.selectedSegmentIndex {
        case 0:
            vDoing.isHidden = true
            cell.proccessPending = processOnCreate[indexPath.row]
        case 1:
            vDoing.isHidden = true
             cell.proccessPending = processRecieved[indexPath.row]
        case 2:
            
            switch indexPath.section{
            case 0:
                cell1.btChoose.isHidden = true
                cell1.vSegment.isHidden = true
                cell1.constraintH.constant = 0
                cell1.btChooseConstraint.constant = 0
                
                if processOnDoing == [] {
                    cell1.backgroundColor = .groupTableViewBackground
                    cell1.isHidden = true
                    return cell1
                }else{
                    cell1.lbOwner.text = "ownerInfor".localize
                    cell1.nameUser.text = processOnDoing[0].stakeholders?.owner?.name
                    cell1.addressName.text = processOnDoing[0].stakeholders?.owner?.address?.name
                    DispatchQueue.global(qos: .userInitiated).async {
                        guard let imag = self.processOnDoing[0].stakeholders?.owner?.image else {return}
                        let url = URL(string: imag)
                        DispatchQueue.main.async {
                            if url == nil {
                                cell1.imageName.image = UIImage(named: "avatar")
                            }else{
                                DispatchQueue.main.async {
                                    cell1.imageName.kf.setImage(with: url)
                                }
                            }
                        }
                    }
                }
                return cell1
            case 1:
                if processOnDoing == [] {
                    cell2.backgroundColor = .groupTableViewBackground
                    cell2.isHidden = true
                    return cell2
                }else{
                    cell2.lbDescription.text = "Description".localize
                    cell2.lbTitle.text = processOnDoing[0].info?.title
                    cell2.lbSubTitle.text = processOnDoing[0].info?.workName?.name
                    cell2.lbComment.text = processOnDoing[0].info?.content
                    cell2.lbDate.text = "\(Date(isoDateString: (processOnDoing[0].workTime?.startAt)!).dayMonthYear)"
                    cell2.lbTime.text = Date(isoDateString: (self.processOnDoing[0].workTime!.startAt)!).hourMinute + " - " + Date(isoDateString: (self.processOnDoing[0].workTime!.endAt)!).hourMinute
                    cell2.lbAddress.text = processOnDoing[0].stakeholders?.owner?.address?.name
                    let tool = processOnDoing[0].info?.tools
                    if  tool == true {
                        cell2.lbTools.isHidden = false
                        cell2.lbTools.text = "Bringyourcleaningsupplies".localize
                    }
                    let salary = processOnDoing[0].info?.salary
                    if salary == 0 {
                        cell2.lbMoney.text = "Timework".localize
                    }else{
                        
                        cell2.lbMoney.text = String().numberFormat(number: salary ?? 0) + " " + "VND"
                    }
                }
                return cell2
            default:
                break
            }
            return UITableViewCell()
        default:
            break
        }
        
        var directWidth:CGFloat = 0
        var deadlineWitdh:CGFloat = 0
        
        DispatchQueue.global(qos: .userInitiated).async {
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
            DispatchQueue.main.async {
                cell.constraintWidthDirect.constant =  directWidth
                cell.contraintWidthDeadline.constant = deadlineWitdh
            }
        }

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
            if processOnDoing == [] {
                
            }else{
                let navi = DetailManagementController(nibName: "DetailManagementController", bundle: nil)
                navi.workPending = processOnDoing[indexPath.row]
                navigationController?.pushViewController(navi, animated: true)
            }
            
            break
        default:
            break
        }
    }
}

