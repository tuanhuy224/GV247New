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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "WorkHistory".localize
    }

    override func setupViewBase() {}

    override func decorate() {
        work != nil ? getTaskComment() : print("Work model is nil now.")
    }

    /*  /en/maid/getTaskComment
     params: task: is task id String
     */
    fileprivate func getTaskComment() {
        guard let taskID = work?.id else {return}
        guard let token = UserDefaultHelper.getToken() else {return}
        let params:[String:Any] = ["task":taskID]
        let headers: HTTPHeaders = ["hbbgvauth": token]
        HistoryServices.sharedInstance.getTaskCommentHistory(url: APIPaths().urlGetTaskCommentWithTaskID(), param: params, header: headers) { (data, err) in
            switch err {
            case .Success:
                guard let jsonData = data else {return}
                self.taskComment = jsonData
                break
            default:
                break
            }
            self.tableView.reloadData()
        }
    }

    fileprivate func configureWorkDetailsCell(cell: InfoDetailCell) {
        
        cell.work = work
        cell.selectionStyle = .none
        cell.constraintDescription.constant = 0
        cell.lbDescription.isHidden = true
        cell.lbDescription.text = "Description".localize
    }

    fileprivate func configureOwnerCommentsCell(cell: WorkerViewCell) {
        cell.work = work
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

