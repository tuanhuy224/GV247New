//
//  HistoryViewController.swift
//  GV24
//
//  Created by HuyNguyen on 5/29/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class HistoryViewController: BaseViewController {
    
    @IBOutlet weak var lbNodata: UILabel!
    @IBOutlet weak var imgNodata: UIImageView!
    var user:User?
    var workList: [Work] = []
    var myParent: ManagerHistoryViewController?
    var page: Int = 1
    var limit: Int = 10
    var startAtDate: Date? = nil
    var endAtDate: Date = Date()
    
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var segmentContainer: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var fromDateContainer: UIView!
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        // configure
        indicator.hidesWhenStopped = true
       return indicator
    }()
    lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(HistoryViewController.updateOwnerList), for: UIControlEvents.valueChanged)
        return refresh
    }()
    
    lazy var emptyLabel: UILabel = {
        let label = TableViewHelper().emptyMessage(message: "", size: CGSize(width: 200, height: 100))
        label.textColor = UIColor.colorWithRedValue(redValue: 109, greenValue: 108, blueValue: 113, alpha: 1)
        label.isHidden = true
        return label
    }()
    lazy var emptyDataView: UIView = {
//        let emptyView = TableViewHelper().noData(frame: CGRect(x: self.view.frame.size.width/2 - 50, y: 50, width: 100, height: 150))
        let emptyView = UIView()//TableViewHelper().noData(frame: .zero)
        emptyView.isHidden = true
        return emptyView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        getWorkList(startAt: startAtDate, endAt: endAtDate)
        
        // add loading indicator at here
        setupLoadingIndicator()
        setupEmptyDataView()
        setupEmptyLabel()
    }
    

    
    func setupLoadingIndicator() {
        view.addSubview(activityIndicatorView)
        activityIndicatorView.center = view.center
    }
    
    func setupEmptyDataView() {
        view.addSubview(emptyDataView)
        emptyDataView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        emptyDataView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        emptyDataView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        emptyDataView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
    }
    
    func setupEmptyLabel(){
        view.addSubview(emptyLabel)
        emptyLabel.frame = CGRect(x: self.view.frame.size.width/2 - 100, y: 0, width: 200, height: 100)
    }
    
    func showLoadingIndicator() {
        if !self.refreshControl.isRefreshing {
            self.activityIndicatorView.startAnimating()
        }
    }
    
    func hideLoadingIndicator() {
        self.activityIndicatorView.stopAnimating()
    }
    
    func updateUI(status: ResultStatus) {
        switch status {
        case .Success:
//            self.historyTableView.isHidden = false
            self.emptyDataView.isHidden = true
            self.emptyLabel.isHidden = true
            
            self.lbNodata.isHidden = true
            self.imgNodata.isHidden = true
        case .EmptyData:
//            self.historyTableView.isHidden = true
            self.emptyDataView.isHidden = false
            self.emptyLabel.isHidden = true
            self.lbNodata.isHidden = false
            self.imgNodata.isHidden = false
            lbNodata.text = "SoonUpdate".localize
            break
        case .LostInternet:
            //self.emptyLabel.text = "NetworkIsLost".localize
//            self.historyTableView.isHidden = true
            self.emptyDataView.isHidden = true
            self.emptyLabel.isHidden = false
            self.lbNodata.isHidden = false
            self.imgNodata.isHidden = false
        default:
            self.emptyLabel.text = "TimeoutExpiredPleaseLoginAgain".localize
//            self.historyTableView.isHidden = true
            self.emptyDataView.isHidden = true
            self.emptyLabel.isHidden = false
            self.lbNodata.isHidden = false
            self.imgNodata.isHidden = false
            break
        }
        self.historyTableView.reloadData()
    }
    func setupTableView() {
        historyTableView.on_register(type: HistoryViewCell.self)
        self.automaticallyAdjustsScrollViewInsets = false
        historyTableView.tableFooterView = UIView()
        self.historyTableView.addSubview(self.refreshControl)
        historyTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: historyTableView.bounds.size.width, height: 0.01))
        self.historyTableView.separatorStyle = .singleLine
        self.historyTableView.backgroundView = self.activityIndicatorView
    }
    
    func updateOwnerList() {
        self.refreshControl.beginRefreshing()
        self.page = 1
        self.workList.removeAll()
        self.historyTableView.reloadData()
        self.getWorkList(startAt: startAtDate, endAt: endAtDate)
        self.refreshControl.endRefreshing()
    }
    
    override func decorate() {}
    
    override func setupViewBase() {}
    
    /* /maid/getHistoryTasks
     Params: startAt (opt), endAt (opt): ISO Date, page, limit: Number
     */
    func getWorkList(startAt: Date?, endAt: Date) {
        showLoadingIndicator()
        user = UserDefaultHelper.currentUser
        var params:[String:Any] = [:]
        if startAt != nil {
            params["startAt"] = "\(String.convertDateToISODateType(date: startAt!)!)"
        }
        params["endAt"] = "\(String.convertDateToISODateType(date: endAt)!)"
        params["page"] = self.page
        params["limit"] = self.limit
        guard let header = UserDefaultHelper.getToken() else {return}
        let headers: HTTPHeaders = ["hbbgvauth": header]
        HistoryServices.sharedInstance.getListWith(object: Work(), url: APIPaths().urlGetWorkListHistory(), param: params, header: headers) { (data, status) in
            
            let stat: ResultStatus = (self.net?.isReachable)! ? status : .LostInternet
            
            if stat == .Success {
                self.workList = data!
            }
            DispatchQueue.main.async {
                self.updateUI(status: stat)
                self.hideLoadingIndicator()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "WorkHistory".localize
        historyTableView.reloadData()
    }
    fileprivate func configureCell(cell: HistoryViewCell, indexPath: IndexPath) {
            let work = workList[indexPath.item]
//        if let imageString = work.info?.workName?.image {
//            let url = URL(string: imageString)
//            cell.imageWork.kf.setImage(with: url)
//            cell.lbDeadline.isHidden = true
//        }
        let url = URL(string: (work.info?.workName?.image)!)
        if url == nil {
            cell.imageWork.image = UIImage(named: "avatar")
        }else{
            DispatchQueue.main.async {
                cell.imageWork.kf.setImage(with:url)
                cell.lbDeadline.isHidden = true
            }
        }
        cell.lbDeadline.isHidden = true
        cell.workNameLabel.text = work.info?.title
        let startAt = work.workTime?.startAt
        let startAtString = String(describing: startAt!)
        let endAt = work.workTime?.endAt
        let endAtString = String(describing: endAt!)
        //cell.timeWork.text = String.convertISODateToString(isoDateStr: startAtString, format: "HH:mm a")! + " - " + String.convertISODateToString(isoDateStr: endAtString, format: "HH:mm a")!
        
        cell.timeWork.text = Date(isoDateString: startAtString).hourMinute +  " - " + Date(isoDateString: endAtString).hourMinute
         cell.lbTimePost.text = "\(Date().dateComPonent(datePost: (work.workTime?.startAt)!))"
        cell.lbDist.text = "CompletedWork".localize
        cell.createdDate.text = String.convertISODateToString(isoDateStr: startAtString, format: "dd/MM/yyyy")
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.workList.count - 1 {
            self.page = self.page + 1
            //self.getWorkList(startAt: self.startAtDate, endAt: self.endAtDate)
        }
    }
}
extension HistoryViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:HistoryViewCell = historyTableView.on_dequeue(idxPath: indexPath)
        self.configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = FinishedWorkViewController()
        vc.work = workList[indexPath.item]
        _ = myParent?.navigationController?.pushViewController(vc, animated: true)
    }
}
extension HistoryViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
