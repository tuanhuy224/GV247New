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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    func setupTableView() {
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UINib(nibName:NibInfoDetailCell,bundle:nil), forCellReuseIdentifier: infoDetailCellID)
        tableView.register(UINib(nibName: NibWorkerViewCell, bundle: nil), forCellReuseIdentifier: workerCellID)
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
            self.tableView.reloadData()
        }
    }

    fileprivate func configureWorkDetailsCell(cell: InfoDetailCell) {
        cell.selectionStyle = .none
        cell.constraintDescription.constant = 0
        cell.lbDescription.isHidden = true
        cell.lbDescription.text = "Description".localize
        if work != nil {
            let url = URL(string: (work?.info?.workName?.image)!)
            if url == nil {
                cell.imageAvatar.image = UIImage(named: "avatar")
            }else{
                cell.imageAvatar.kf.setImage(with:url)
            }
            cell.lbTitle.text = work?.info?.title
            cell.lbSubTitle.text = work?.info?.workName?.name
            cell.lbComment.text = work?.info?.content
//            cell.lbDes.text = "Description".localize
//            cell.lbDes.font = fontSize.fontName(name: .regular, size: 16)
//            let salary = work?.info?.salary
//            let salaryText = String(describing: salary!)
//            cell.lbMoney.text = salaryText + " VND"
            
            let salary = work?.info?.salary
            if salary == 0 {
                cell.lbMoney.text = "Timework".localize
            }else{
                
                cell.lbMoney.text = String().numberFormat(number: salary ?? 0) + " " + "VND"
            }
            
            let startAt = work?.workTime?.startAt
            let startAtStr = String(describing: startAt!)
            cell.lbDate.text = String.convertISODateToString(isoDateStr: startAtStr, format: "dd/MM/yyyy")
            cell.lbAddress.text = work?.info?.address?.name
            
            let endAt = work?.workTime?.endAt
            let endAtStr = String(describing: endAt!)
            cell.lbTime.text = Date(isoDateString: startAtStr).hourMinute + " - " + Date(isoDateString: endAtStr).hourMinute
            
            let tool = work?.info?.tools
            if  tool == true {
                cell.lbTools.isHidden = false
                cell.lbTools.text = "Bringyourcleaningsupplies".localize
            }
        }
    }

    fileprivate func configureOwnerCommentsCell(cell: WorkerViewCell) {
        if work != nil {
            let url = URL(string: (work?.stakeholders?.owner?.image)!)
            if url == nil {
                cell.imageUser.image = UIImage(named: "avatar")
            }else{
                cell.imageUser.kf.setImage(with:url)

            }
            cell.imageUser.layer.cornerRadius = cell.imageUser.frame.width / 2
            cell.imageUser.clipsToBounds = true
            cell.nameLabel.text = work?.stakeholders?.owner?.name!
            cell.addressLabel.text = work?.stakeholders?.owner?.address?.name!
            cell.workCompletedLabel.text = "CompletedWork".localize
        }
        
        if let comment = taskComment?.content {
            cell.commentLabel.isHidden = false
            cell.separateLine.isHidden = false
            cell.commentLabel.text = comment
        } else {
            cell.commentLabel.isHidden = true
            cell.separateLine.isHidden = true
            cell.commentLabel.text = ""
        }
    
    }

}

extension FinishedWorkViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell:InfoDetailCell = tableView.dequeueReusableCell(withIdentifier: infoDetailCellID, for: indexPath) as! InfoDetailCell

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
        return section == 0 ? "Description".localize.uppercased() : "Owner".localize.uppercased()
    }
}

