//
//  FinishedWorkViewController.swift
//  GV24
//
//  Created by admin on 6/6/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire
import SwiftyJSON

class FinishedWorkViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var work: Work?
    var taskComment:Comment?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        
//        tableView.setNeedsLayout()
//        tableView.layoutIfNeeded()
        
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.register(UINib(nibName: "FinishedWorkCell", bundle: nil), forCellReuseIdentifier: "FinishedWorkCell")
        tableView.register(UINib(nibName: "WorkerViewCell", bundle: nil), forCellReuseIdentifier: "WorkerCell")
        
        if work != nil {
            tableView.reloadData()
        }
        //print("TASK ID = \(work?.id)")
        tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Công việc hoàn thành"
        
    }
    
    override func setupViewBase() {
        
    }
    
    override func decorate() {
        work != nil ? getTaskComment() : print("Work model is nil now.")
    }
    
    /*  /en/maid/getTaskComment
     params: task: is task id String
     */
    fileprivate func getTaskComment() {
        print("\(work?.id)")
        let taskID = work?.id
        let params:[String:Any] = ["task":"\(String(describing: taskID!))"]
        let headers: HTTPHeaders = ["hbbgvauth": "\(UserDefaultHelper.getToken()!)"]
        HistoryServices.sharedInstance.getTaskCommentHistory(url: APIPaths().urlGetTaskCommentWithTaskID(), param: params, header: headers) { (data, err) in
            if err == nil {
                if data != nil {
                    self.taskComment = data!
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                else {
                    print("Data not exists nhes")
                }
            }
            else {
                print("Error occurred while getting task comment in FinishedWorkViewController")
            }
        }
    }
    
    fileprivate func configureWorkDetailsCell(cell: FinishedWorkCell) {
        cell.selectionStyle = .none
        if let imageString = work?.info?.workName?.image {
            let url = URL(string: imageString)
            cell.workImage.kf.setImage(with: url, placeholder: UIImage(named: "nau an"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        
        cell.workNameLabel.text = work?.info?.title
        cell.workTypeLabel.text = work?.info?.workName?.name
        cell.workContentLabel.text = work?.info?.content
        
        let salary = work?.info?.salary
        let salaryText = String(describing: salary!)
        cell.workSalaryLabel.text = salaryText + " VND"
        
        let startAt = work?.workTime?.startAt
        let startAtStr = String(describing: startAt!)
        cell.workCreateAtLabel.text = String.convertISODateToString(isoDateStr: startAtStr, format: "dd/MM/yyyy")
        cell.workAddressLabel.text = work?.info?.address?.name
        
        let endAt = work?.workTime?.endAt
        let endAtStr = String(describing: endAt!)
        cell.workTimeLabel.text = String.convertISODateToString(isoDateStr: startAtStr, format: "HH:mm a")! + " - " + String.convertISODateToString(isoDateStr: endAtStr, format: "HH:mm a")!
    }
    
    fileprivate func configureOwnerCommentsCell(cell: WorkerViewCell) {
        if let imageString = work?.stakeholders?.owner?.image {
            let url = URL(string: imageString)
            cell.imageUser.kf.setImage(with: url, placeholder: UIImage(named: "nau an"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        cell.imageUser.layer.cornerRadius = cell.imageUser.frame.width / 2
        cell.imageUser.clipsToBounds = true
        cell.nameLabel.text = work?.stakeholders?.owner?.name!
        cell.addressLabel.text = work?.stakeholders?.owner?.address?.name!
        cell.commentLabel.text = self.taskComment?.content!

    }

}

extension FinishedWorkViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.taskComment == nil {
            return 1
        }
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FinishedWorkCell", for: indexPath) as! FinishedWorkCell
            
            self.configureWorkDetailsCell(cell: cell)
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WorkerCell", for: indexPath) as! WorkerViewCell
            
            self.configureOwnerCommentsCell(cell: cell)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension FinishedWorkViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 0 {
//            return 221
//        }
//        return 170
//    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "NGƯỜI THỰC HIỆN"
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.lightGray
        header.textLabel?.font = UIFont(name: "SF UI Text Light", size: 16)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
}
