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
    var processOnCreate = [Work](){
        didSet{
            tbManage.reloadData()
        }
    }
    var processPending = [Work]()
    var processDone = [Work]()
    var processOnDoing = [Work](){
        didSet{
            tbManage.reloadData()
        }
    }
    var processRecieved = [Work](){
        didSet{
            tbManage.reloadData()
        }
    }
    var returnValue:Int = 0
    var longGesture = UILongPressGestureRecognizer()
    override func viewDidLoad() {
        super.viewDidLoad()
        tbManage.on_register(type: HistoryViewCell.self)
        tbManage.register(UINib(nibName:NibWorkDetailCell,bundle:nil), forCellReuseIdentifier: workDetailCellID)
        tbManage.register(UINib(nibName:NibInfoDetailCell,bundle:nil), forCellReuseIdentifier: infoDetailCellID)
        tbManage.separatorStyle = .none
        self.title = "Titlemanagement".localize
        self.tbManage.rowHeight = UITableViewAutomaticDimension
        self.tbManage.estimatedRowHeight = 100.0
        vDoing.isHidden = true
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
        tbManage.reloadData()
        if processOnDoing == [] {
            return
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        guard let token = UserDefaultHelper.getToken() else{return}
        let parameterCreate = ["process":"\(WorkStatus.OnCreate.rawValue)"]
        let parmaterPending = ["process":"\(WorkStatus.Pending.rawValue)"]
        let parmaterOnDoing = ["process":"\(WorkStatus.OnDoing.rawValue)"]
        let parmaterRecieve = ["process":"\(WorkStatus.Recieved.rawValue)"]
        let header = ["hbbgvauth":token]
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
            
            if processOnCreate[indexPath.row].process?.id == WorkStatus.Direct.rawValue  && Date(isoDateString: (processOnCreate[indexPath.row].workTime?.endAt)!).comparse == true {
                cell.lbDirect.isHidden = true
                cell.lbDeadline.isHidden = false
                cell.lbDeadline.text = "Expired".localize
            }else if Date(isoDateString: (processOnCreate[indexPath.row].workTime?.endAt)!).comparse == true{
                cell.lbDirect.isHidden = true
                cell.lbDeadline.isHidden = false
                cell.lbDeadline.text = "Expired".localize
                
            }else if processOnCreate[indexPath.row].process?.id == WorkStatus.OnCreate.rawValue {
                cell.lbDirect.isHidden = true
                cell.lbDeadline.isHidden = true
                cell.constraintWidthDirect.constant = 0
                cell.contraintWidthDeadline.constant = 0
                
                
            }else{
                cell.lbDirect.isHidden = false
                cell.lbDeadline.isHidden = true
                cell.lbDirect.text = "Direct".localize
            }
            cell.workNameLabel.text = processOnCreate[indexPath.row].info?.title
            cell.createdDate.text = "\(Date(isoDateString: (processOnCreate[indexPath.row].workTime?.startAt)!).dayMonthYear)"
            cell.lbDist.text = "Proccess".localize
            cell.lbTimePost.text = "\(Date().dateComPonent(datePost: (processOnCreate[indexPath.row].history?.createAt)!))"
            UserDefaultHelper.setUserOwner(user: processOnCreate[indexPath.row].stakeholders?.owner)
            cell.timeWork.text = Date(isoDateString: (processOnCreate[indexPath.row].workTime?.startAt)!).hourMinute + " - " + Date(isoDateString: (processOnCreate[indexPath.row].workTime?.endAt)!).hourMinute
            
            
            
            
        case 1:
            vDoing.isHidden = true
            cell.workNameLabel.text = processRecieved[indexPath.row].info?.title
            cell.createdDate.text = "\(Date(isoDateString: (processRecieved[indexPath.row].workTime?.startAt)!).dayMonthYear)"
            cell.lbTimePost.text = "\(Date().dateComPonent(datePost: (processRecieved[indexPath.row].history?.createAt)!))"
            cell.timeWork.text = "\(Date(isoDateString: (processRecieved[indexPath.row].workTime?.startAt)!).hourMinute)\(" - ")\(Date(isoDateString: (processRecieved[indexPath.row].workTime?.endAt)!).hourMinute)"
            cell.lbDist.text = processRecieved[indexPath.row].process?.name?.localize
            if processRecieved[indexPath.row].process?.id == WorkStatus.Direct.rawValue  && Date(isoDateString: (processRecieved[indexPath.row].workTime?.endAt)!).comparse == true {
                cell.lbDirect.isHidden = true
                cell.lbDeadline.isHidden = false
                cell.lbDeadline.text = "Expired".localize
            }else if Date(isoDateString: (processRecieved[indexPath.row].workTime?.endAt)!).comparse == true{
                cell.lbDirect.isHidden = true
                cell.lbDeadline.isHidden = false
                cell.lbDeadline.text = "Expired".localize
            }else{
                cell.lbDeadline.isHidden = true
                cell.lbDirect.isHidden = true
                cell.constraintWidthDirect.constant = 0
            }
            
        case 2:
            
            switch indexPath.section{
            case 0:
                cell1.btChoose.isHidden = true
                cell1.vSegment.isHidden = true
                cell1.heightBtChoose.constant = 0
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
                    let url = URL(string: (processOnDoing[0].stakeholders?.owner?.image)!)!
                    if url == nil {
                        cell1.imageName.image = UIImage(named: "avatar")
                    }else{
                        DispatchQueue.main.async {
                            cell1.imageName.kf.setImage(with: url)
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

