//
//  DistanceViewController.swift
//  GV24
//
//  Created by dinhphong on 9/5/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import UIKit

protocol DistanceDelegate {
    func selected(_ tableDistance: UITableView, at index: IndexPath)
}

class DistanceViewController: BaseViewController {
   
    let cellId = "cellId"
    var delegate: DistanceDelegate?
    
    lazy var tableDistance: UITableView = {
        let tbv = UITableView()
        tbv.translatesAutoresizingMaskIntoConstraints = false
        tbv.backgroundColor = .clear
        tbv.separatorStyle = .singleLine
        tbv.rowHeight = UITableViewAutomaticDimension
        tbv.estimatedRowHeight = 100
        tbv.dataSource = self
        tbv.delegate = self
        return tbv
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Khoảng cách"
        self.view.backgroundColor = .white
        
        setupView()
        
        tableDistance.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setupView() {
        self.view.addSubview(tableDistance)
        
        view.addConstraintWithFormat(format: "H:|[v0]|", views: tableDistance)
        view.addConstraintWithFormat(format: "V:|[v0]|", views: tableDistance)
        
    }
}
extension DistanceViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = "\(indexPath.item) km"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selected(tableView, at: indexPath)
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
