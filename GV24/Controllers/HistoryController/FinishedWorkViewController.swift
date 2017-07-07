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
    var taskComment:Comment? = nil
    var isWorkListComing: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    func setupTableView() {
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.register(UINib(nibName: NibFinishedWorkCell, bundle: nil), forCellReuseIdentifier: finishedWorkCellID)
        tableView.register(UINib(nibName: NibWorkerViewCell, bundle: nil), forCellReuseIdentifier: workerCellID)
        tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "WorkHistory".localize//"Công việc hoàn thành"
    }

    override func setupViewBase() {}

    override func decorate() {
        work != nil ? getTaskComment() : print("Work model is nil now.")
    }

    /*  /en/maid/getTaskComment
     params: task: is task id String
     */
    fileprivate func getTaskComment() {
        let taskID = work?.id
        let params:[String:Any] = ["task":"\(String(describing: taskID!))"]
        let headers: HTTPHeaders = ["hbbgvauth": "\(UserDefaultHelper.getToken()!)"]
        HistoryServices.sharedInstance.getTaskCommentHistory(url: APIPaths().urlGetTaskCommentWithTaskID(), param: params, header: headers) { (data, err) in
            switch err {
            case .Success:
                self.taskComment = data!
                break
            default:
                break
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    fileprivate func configureWorkDetailsCell(cell: FinishedWorkCell) {
        cell.selectionStyle = .none
        if work != nil {
//            if let imageString = work?.info?.workName?.image {
//                let url = URL(string: imageString)
//                DispatchQueue.main.async {
//                    cell.workImage.kf.setImage(with: url)
//                }
//            }
            let url = URL(string: (work?.info?.workName?.image)!)
            if url == nil {
                cell.workImage.image = UIImage(named: "avatar")
            }else{
                DispatchQueue.main.async {
                    cell.workImage.kf.setImage(with:url)
                }
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
    }

    fileprivate func configureOwnerCommentsCell(cell: WorkerViewCell) {
        if work != nil {
            let url = URL(string: (work?.stakeholders?.owner?.image)!)
            if url == nil {
                cell.imageUser.image = UIImage(named: "avatar")
            }else{
                DispatchQueue.main.async {
                    cell.imageUser.kf.setImage(with:url)
                }
            }
            cell.imageUser.layer.cornerRadius = cell.imageUser.frame.width / 2
            cell.imageUser.clipsToBounds = true
            cell.nameLabel.text = work?.stakeholders?.owner?.name!
            cell.addressLabel.text = work?.stakeholders?.owner?.address?.name!
            cell.workCompletedLabel.text = "CompletedWork".localize
        }
    
        if isWorkListComing == true {
            //cell.btnComment.isHidden = false
            cell.commentLabel.isHidden = true
        }
        else {
            //cell.btnComment.isHidden =  true
            cell.commentLabel.isHidden = false
            cell.commentLabel.text = self.taskComment?.content!
        }
    }

}

extension FinishedWorkViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.taskComment == nil {
            if isWorkListComing == true {
                return 2
            }
            return 1
        }
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: finishedWorkCellID, for: indexPath) as! FinishedWorkCell

            self.configureWorkDetailsCell(cell: cell)

            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: workerCellID, for: indexPath) as! WorkerViewCell

            self.configureOwnerCommentsCell(cell: cell)

            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            let vc = DetailManagementController()
            vc.workPending = self.work
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension FinishedWorkViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            if isWorkListComing == true {
                return "Owner".localize
            }
            return "Doer".localize
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

