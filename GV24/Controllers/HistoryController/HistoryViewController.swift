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
    var workList: [Work] = []{
        didSet{
            historyTableView.reloadData()
        }
    }
    var myParent: ManagerHistoryViewController?
    var page: Int = 1
    var limit: Int = 10
    var startAtDate: Date? = nil
    var endAtDate: Date = Date()
    
    @IBOutlet weak var historyTableView: UITableView!
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        // configure
        indicator.hidesWhenStopped = true
        return indicator
    }()
    lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(HistoryViewController.updateOwnerList), for: .valueChanged)
        return refresh
    }()
    
    lazy var emptyLabel: UILabel = {
        let label = TableViewHelper().emptyMessage(message: "", size: CGSize(width: 200, height: 100))
        label.textColor = AppColor.backButton
        label.isHidden = true
        return label
    }()
    lazy var emptyDataView: UIView = {
        
        let emptyView = UIView()
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
        //        emptyDataView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        //        emptyDataView.heightAnchor.constraint(equalToConstant: 150).isActive = true
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
            self.emptyDataView.isHidden = true
            self.emptyLabel.isHidden = true
            
            self.lbNodata.isHidden = true
            self.imgNodata.isHidden = true
        case .EmptyData:
            self.emptyDataView.isHidden = false
            self.emptyLabel.isHidden = true
            self.lbNodata.isHidden = false
            self.imgNodata.isHidden = false
            lbNodata.text = "SoonUpdate".localize
            break
        case .LostInternet:
            self.emptyDataView.isHidden = true
            self.emptyLabel.isHidden = false
            self.lbNodata.isHidden = false
            self.imgNodata.isHidden = false
        default:
            self.emptyLabel.text = "TimeoutExpiredPleaseLoginAgain".localize
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
        //        self.automaticallyAdjustsScrollViewInsets = false
        //        historyTableView.tableFooterView = UIView()
        historyTableView.addSubview(self.refreshControl)
        historyTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 0.01))
        self.historyTableView.separatorStyle = .singleLine
        self.historyTableView.backgroundView = self.activityIndicatorView
        historyTableView.rowHeight = UITableViewAutomaticDimension
        historyTableView.estimatedRowHeight = 100
        if #available(iOS 10.0, *) {
            historyTableView.refreshControl = refreshControl
        } else {
            // Fallback on earlier versions
        }
    }
    
    func updateOwnerList() {
        self.refreshControl.beginRefreshing()
        self.page = 1
        self.workList.removeAll()
        self.historyTableView.reloadData()
        self.getWorkList(startAt: startAtDate, endAt: endAtDate)
        self.refreshControl.endRefreshing()
    }
    
    /* /maid/getHistoryTasks
     Params: startAt (opt), endAt (opt): ISO Date, page, limit: Number
     */
    func getWorkList(startAt: Date?, endAt: Date) {
        loadingView.show()
        user = UserDefaultHelper.currentUser
        var params:[String:Any] = [:]
        if startAt != nil {
            params["startAt"] = Date.convertedDateToString(date: startAt!)
        }
        params["endAt"] = Date.convertedDateToString(date: endAt)
        params["page"] = self.page
        params["limit"] = self.limit
        guard let header = UserDefaultHelper.getToken() else {return}
        let headers: HTTPHeaders = ["hbbgvauth": header]
        HistoryServices.sharedInstance.getListWith(object: Work(), url: APIPaths().urlGetWorkListHistory(), param: params, header: headers) { (data, status) in
            self.loadingView.close()
            let stat: ResultStatus = (self.net?.isReachable)! ? status : .LostInternet
            
            if stat == .Success {
                guard let jsonData = data else {return}
                self.workList = jsonData
            }
            DispatchQueue.main.async {
                self.updateUI(status: stat)
            }
            self.historyTableView.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "WorkHistory".localize
    }
    fileprivate func configureCell(cell: HistoryViewCell, indexPath: IndexPath) {
        cell.proccessPending = workList[indexPath.row]
        cell.lbDist.text = "CompletedWork".localize
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.workList.count - 1 {
            self.page = self.page + 1
        }
    }
}
extension HistoryViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:HistoryViewCell = historyTableView.on_dequeue(idxPath: indexPath)
        self.configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = FinishedWorkViewController()
        vc.work = workList[indexPath.item]
        navigationController?.pushViewController(vc, animated: true)
    }
}

