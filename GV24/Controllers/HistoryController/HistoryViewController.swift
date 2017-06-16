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
       return UIActivityIndicatorView(activityIndicatorStyle: .gray)
    }()
    lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(HistoryViewController.updateOwnerList), for: UIControlEvents.valueChanged)
        return refresh
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        getWorkList(startAt: startAtDate, endAt: endAtDate)
    }
    
    func setupTableView() {
        historyTableView.register(UINib(nibName:"HistoryViewCell",bundle:nil), forCellReuseIdentifier: "historyCell")
        self.automaticallyAdjustsScrollViewInsets = false
        historyTableView.tableFooterView = UIView()
        self.historyTableView.addSubview(self.refreshControl)
        historyTableView.backgroundView = self.activityIndicatorView
        self.historyTableView.separatorStyle = .singleLine
    }
    
    func updateOwnerList() {
        self.refreshControl.endRefreshing()
        self.page = 1
        self.workList.removeAll()
        self.historyTableView.reloadData()
        self.getWorkList(startAt: startAtDate, endAt: endAtDate)
    }
    
    override func decorate() {}
    
    override func setupViewBase() {}
    
    /* /maid/getHistoryTasks
     Params: startAt (opt), endAt (opt): ISO Date, page, limit: Number
     */
    func getWorkList(startAt: Date?, endAt: Date) {
        self.historyTableView.backgroundView = self.activityIndicatorView
        self.activityIndicatorView.startAnimating()
        user = UserDefaultHelper.currentUser
        var params:[String:Any] = [:]
        if startAt != nil {
            params["startAt"] = "\(String.convertDateToISODateType(date: startAt!)!)"
        }
        params["endAt"] = "\(String.convertDateToISODateType(date: endAt)!)"
        params["page"] = self.page
        params["limit"] = self.limit
        let headers: HTTPHeaders = ["hbbgvauth": "\(UserDefaultHelper.getToken()!)"]
        HistoryServices.sharedInstance.getWorkListWith(status: WorkStatus.Done, url: APIPaths().urlGetWorkListHistory(), param: params, header: headers) { (data, err) in
            if err == nil {
                if data != nil {
                    if (data?.count)! > 0 {
                        self.workList.append(contentsOf: data!)
                        TableViewHelper().stopActivityIndicatorView(activityIndicatorView: self.activityIndicatorView, message: nil, tableView: self.historyTableView, isReload: true)
                    }
                    else {
                        TableViewHelper().stopActivityIndicatorView(activityIndicatorView: self.activityIndicatorView, message: "YouDontHaveAnyData".localize, tableView: self.historyTableView, isReload: false)
                    }
                }
            }
            else {
                TableViewHelper().stopActivityIndicatorView(activityIndicatorView: self.activityIndicatorView, message: "ErrorFetchingDataFromServer".localize, tableView: self.historyTableView, isReload: false)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "WorkHistory".localize//"Lịch sự công việc"
    }
    
    fileprivate func configureCell(cell: HistoryViewCell, indexPath: IndexPath) {
        let work = workList[indexPath.item]
        if let imageString = work.info?.workName?.image {
            let url = URL(string: imageString)
            cell.imageWork.kf.setImage(with: url, placeholder: UIImage(named: "nau an"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        
        cell.workNameLabel.text = work.info?.title
        
        let startAt = work.workTime?.startAt
        let startAtString = String(describing: startAt!)
        let endAt = work.workTime?.endAt
        let endAtString = String(describing: endAt!)
        
        cell.createdDate.text = String.convertISODateToString(isoDateStr: startAtString, format: "dd/MM/yyyy")
        
        let now = Date()
        let startAtDate = String.convertISODateToDate(isoDateStr: startAtString)
        
        let executionTime = now.timeIntervalSince(startAtDate!)
        let secondsInHour: Double = 3600
        let hoursBetweenDates = Int(executionTime/secondsInHour)
        let daysBetweenDates = Int(executionTime/86400)
        let minutesBetweenDates = Int(executionTime/60)
        
        if minutesBetweenDates > 60 {
            cell.lbTimePost.text = "\(daysBetweenDates) \("Date".localize) \(Int(hoursBetweenDates/24)) \("Hour".localize)"
        }
        else {
            cell.lbTimePost.text = "\(minutesBetweenDates) \("MinutesAgo".localize)"
        }
        
        cell.timeWork.text = String.convertISODateToString(isoDateStr: startAtString, format: "HH:mm a")! + " - " + String.convertISODateToString(isoDateStr: endAtString, format: "HH:mm a")!
        
        cell.lbDist.text = "Completed".localize
        
//        if indexPath.row == workList.count - 1 {
//            self.activityIndicatorView.startAnimating()
//            page = page + 1
//            self.getWorkList(startAt: self.startAtDate, endAt: endAtDate)
//        }
    }
}

extension HistoryViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = historyTableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryViewCell
        self.configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = FinishedWorkViewController()
        vc.work = workList[indexPath.item]
        let backItem = UIBarButtonItem()
        backItem.title = "Back".localize
        navigationItem.backBarButtonItem = backItem
        _ = myParent?.navigationController?.pushViewController(vc, animated: true)
    }
}
extension HistoryViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
