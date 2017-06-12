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
    
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var segmentContainer: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var fromDateContainer: UIView!
    
    var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyTableView.register(UINib(nibName:"HistoryViewCell",bundle:nil), forCellReuseIdentifier: "historyCell")
        
        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
        historyTableView.tableFooterView = UIView()
        self.activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        historyTableView.backgroundView = self.activityIndicatorView
        getWorkList(startAt: nil, endAt: Date())
    }
    
    override func decorate() {}
    
    override func setupViewBase() {}
    
    /* /maid/getHistoryTasks
     Params: startAt (opt), endAt (opt): ISO Date, page, limit: Number
     */
    func getWorkList(startAt: Date?, endAt: Date) {
        self.activityIndicatorView.startAnimating()
        user = UserDefaultHelper.currentUser
        var params:[String:Any] = [:]
        if startAt != nil {
            params["startAt"] = String.convertDateToISODateType(date: startAt!)
        }
        params["endAt"] = String.convertDateToISODateType(date: endAt)
        
        let headers: HTTPHeaders = ["hbbgvauth": "\(UserDefaultHelper.getToken()!)"]
        HistoryServices.sharedInstance.getWorkListWith(status: WorkStatus.Done, url: APIPaths().urlGetWorkListHistory(), param: params, header: headers) { (data, err) in
            if err == nil {
                if data != nil {
                    self.workList.append(contentsOf: data!)
                    DispatchQueue.main.async {
                        self.activityIndicatorView.stopAnimating()
                        self.historyTableView.reloadData()
                    }
                }
            }
            else {
                print("Error occurred while geting work list with Work status is Done in HistoryViewController")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Lịch sự công việc"
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
            cell.estimateWorkTime.text = "\(daysBetweenDates) ngày \(Int(hoursBetweenDates/24)) tiếng"
        }
        else {
            cell.estimateWorkTime.text = "\(minutesBetweenDates) phút trước"
        }
        
        cell.timeWork.text = String.convertISODateToString(isoDateStr: startAtString, format: "HH:mm a")! + " - " + String.convertISODateToString(isoDateStr: endAtString, format: "HH:mm a")!
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
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        _ = myParent?.navigationController?.pushViewController(vc, animated: true)
    }
}
extension HistoryViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
