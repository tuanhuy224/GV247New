//
//  FinishedWorkViewController.swift
//  GV24
//
//  Created by admin on 6/6/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Kingfisher

class FinishedWorkViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var work: Work?
//    var ownerCommentList:[]
    
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
        print("TASK ID = \(work?.id)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Công việc hoàn thành"
    }
    
    fileprivate func configureWorkDetailsCell(cell: FinishedWorkCell) {
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
//        if let imageString = work?.info?.workName?.image {
//            let url = URL(string: imageString)
//            cell.workImage.kf.setImage(with: url, placeholder: UIImage(named: "nau an"), options: nil, progressBlock: nil, completionHandler: nil)
//        }
        
        cell.commentLabel.text = "Bạn siêng năng, dọn phòng đúng sạch sẽ gọn gàng, đi làm đúng giờBạn siêng năng, dọn phòng đúng sạch sẽ gọn gàng, đi làm đúng giờBạn siêng năng, dọn phòng đúng sạch sẽ gọn gàng, đi làm đúng giờBạn siêng năng, dọn phòng đúng sạch sẽ gọn gàng, đi làm đúng giờ"
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "FinishedWorkCell", for: indexPath) as! FinishedWorkCell
            
            self.configureWorkDetailsCell(cell: cell)
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WorkerCell", for: indexPath) as! WorkerViewCell
            
            self.configureOwnerCommentsCell(cell: cell)
            
            return cell
        }
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
