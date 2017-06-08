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
    
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var segmentContainer: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var fromDateContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyTableView.register(UINib(nibName:"HistoryViewCell",bundle:nil), forCellReuseIdentifier: "historyCell")
        
        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        self.automaticallyAdjustsScrollViewInsets = false
        customControl()
        print("token = \(UserDefaultHelper.getToken()!)")
    }
    
    override func decorate() {
        getWorkList()
        
    }
    
    override func setupViewBase() {
        
    }
    
    func getWorkList() {
        user = UserDefaultHelper.currentUser
        let params = ["process_ID":000000000000000000000005]
        let headers: HTTPHeaders = ["hbbgvauth": "\(UserDefaultHelper.getToken()!)"]
        HistoryServices.sharedInstance.getWorkListWith(status: WorkStatus.Done, url: APIPaths().urlGetWorkListHistory(), param: params, header: headers) { (data, err) in
            if err == nil {
                if data != nil {
                    self.workList.append(contentsOf: data!)
                    DispatchQueue.main.async {
                        self.historyTableView.reloadData()
                    }
                }
            }
            else {
                print("Error occurred while geting work list with Work status is Done.")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Lịch sự công việc"
        segmentControl.selectedSegmentIndex = 0
    }
    
    @IBAction func segmentValueChanged(_ segment: UISegmentedControl) {
        switch segment.selectedSegmentIndex {
        case 0:
            print("Do nothing.")
            break;
        case 1:
            let vc = OwnerHistoryViewController()
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
            navigationController?.pushViewController(vc, animated: true)
            break;
        default:
            print("")
        }
    }
    
    fileprivate func customControl() {
        let topBorder = UIView(frame: CGRect(x: 0, y: 0, width: fromDateContainer.frame.size.width, height: 1.0))
        topBorder.backgroundColor = UIColor.lightGray
        topBorder.alpha = 0.3
        let bottomBorder = UIView(frame: CGRect(x: 0, y: segmentContainer.frame.size.height - 1, width: segmentContainer.frame.size.width, height: 1.0))
        bottomBorder.backgroundColor = UIColor.lightGray
        bottomBorder.alpha = 0.3
        fromDateContainer.addSubview(topBorder)
        fromDateContainer.addSubview(bottomBorder)
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
        _ = navigationController?.pushViewController(vc, animated: true)
        
    }
}
extension HistoryViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
