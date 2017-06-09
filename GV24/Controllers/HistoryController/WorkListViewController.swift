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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
        let nib = UINib(nibName: "HistoryViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "historyCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Danh sách công việc"
    }

    override func setupViewBase() {
        
    }
    
    override func decorate() {
        getWorkListWith()
    }
    
    fileprivate func getWorkListWith() {
        //let params:[String:AnyObject] = [:]
        //let headers: HTTPHeaders = ["hbbgvauth": "\(UserDefaultHelper.getToken()!)"]
        
    }
    
    func configureCell(cell: HistoryViewCell, indexPath: IndexPath) {
      /*  let work = list[indexPath.item]
        
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
        */
    }
    
}

extension WorkListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryViewCell
        
        self.configureCell(cell: cell, indexPath: indexPath)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = FinishedWorkViewController()
//        vc.work = list[indexPath.item]
        //check if no comment or there is an comment
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension WorkListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

