//
//  WorkListViewController.swift
//  GV24
//
//  Created by admin on 6/9/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import SwiftyJSON

class WorkListViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var list:[Work] = []
    var owner: Owner?
    var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(WorkListViewController.updateOwnerList), for: UIControlEvents.valueChanged)
        return refresh
    }()
    var activityIndicatorView: UIActivityIndicatorView = {
        return UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    }()
    var page: Int = 1
    var limit: Int = 10
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        getTaskOfOwner()
    }
    
    func setupTableView() {
        self.automaticallyAdjustsScrollViewInsets = false
        let nib = UINib(nibName: "HistoryViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "historyCell")
        self.tableView.addSubview(self.refreshControl)
        self.tableView.backgroundView = self.activityIndicatorView
    }
    
    @objc fileprivate func updateOwnerList(){
        self.refreshControl.endRefreshing()
        self.page = 1
        self.list.removeAll()
        self.tableView.reloadData()
        self.getTaskOfOwner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "WorkList".localize//"Danh sách công việc"
    }

    override func setupViewBase() {}
    
    override func decorate() {
    }
    
    /*  GET: /maid/getTaskOfOwner owner: ownerId
     startAt, endAt (opt): ISODate
     page, limit (opt): number (int)
     */
    fileprivate func getTaskOfOwner() {
        self.tableView.backgroundView = self.activityIndicatorView
        self.activityIndicatorView.startAnimating()
        var params:[String:Any] = [:]
        params["owner"] = "\((owner?.id)!)"
        params["page"] = self.page
        params["limit"] = self.limit
        let headers: HTTPHeaders = ["hbbgvauth": "\(UserDefaultHelper.getToken()!)"]
        OwnerServices.sharedInstance.getTaskOfOwner(url: APIPaths().urlGetTaskOfOwner(), param: params, header: headers) { (data, error) in
            if error == nil {
                if data != nil {
                    if (data?.count)! > 0 {
                        self.list.append(contentsOf: data!)
                        TableViewHelper().stopActivityIndicatorView(activityIndicatorView: self.activityIndicatorView, message: nil, tableView: self.tableView, isReload: true)
                    }
                    else {
                        TableViewHelper().stopActivityIndicatorView(activityIndicatorView: self.activityIndicatorView, message: "YouDontHaveAnyData".localize, tableView: self.tableView, isReload: false)
                    }
                }
                else {
                    TableViewHelper().stopActivityIndicatorView(activityIndicatorView: self.activityIndicatorView, message: "YouDontHaveAnyData".localize, tableView: self.tableView, isReload: false)
                }
            }
            else {
                TableViewHelper().stopActivityIndicatorView(activityIndicatorView: self.activityIndicatorView, message: "ErrorFetchingDataFromServer".localize, tableView: self.tableView, isReload: false)
            }
        }
    }
    
    func configureCell(cell: HistoryViewCell, indexPath: IndexPath) {
        if list.count != 0 {
            let work = list[indexPath.item]
            
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
        }
    }
}

extension WorkListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryViewCell
        self.configureCell(cell: cell, indexPath: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = FinishedWorkViewController()
        vc.work = list[indexPath.item]
        vc.isWorkListComing = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension WorkListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

