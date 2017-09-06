//
//  WorkTypeViewController.swift
//  GV24
//
//  Created by dinhphong on 9/5/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import UIKit


protocol WorkTypeDelegate {
    func selected(_ tableWorkType: UITableView, _ work: WorkType?)
}
class WorkTypeViewController: BaseViewController {
    
    let cellId = "cellId"
    var worksType = [WorkType]()
    var delegate: WorkTypeDelegate?
    
    lazy var tableWorkType: UITableView = {
        let tbv = UITableView()
        tbv.translatesAutoresizingMaskIntoConstraints = false
        tbv.backgroundColor = .clear
        tbv.tableFooterView = UIView()
        tbv.separatorStyle = .singleLine
        tbv.rowHeight = UITableViewAutomaticDimension
        tbv.estimatedRowHeight = 100
        tbv.dataSource = self
        tbv.delegate = self
        return tbv
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Loại công việc"
        self.view.backgroundColor = .white
        
        setupView()
        
        tableWorkType.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        loadingView.show()
        AroundTask.sharedInstall.getWorkType(APIPaths().getWorkAll) { (works, error) in
            self.loadingView.close()
            if error == nil {
                self.worksType = works!
                self.tableWorkType.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setupView() {
        self.view.addSubview(tableWorkType)
        
        view.addConstraintWithFormat(format: "H:|[v0]|", views: tableWorkType)
        view.addConstraintWithFormat(format: "V:|[v0]|", views: tableWorkType)
    }
    
}
extension WorkTypeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return worksType.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.selectionStyle = .none
        if indexPath.row == worksType.count {
            cell.textLabel?.text = "Tất cả"
        }else {
            cell.textLabel?.text = worksType[indexPath.row].name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == worksType.count {
            delegate?.selected(tableView, nil)
        }else{
            delegate?.selected(tableView, worksType[indexPath.row])
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

}
