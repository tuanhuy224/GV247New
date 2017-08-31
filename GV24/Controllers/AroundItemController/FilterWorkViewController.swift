//
//  FilterWorkViewController.swift
//  GV24
//
//  Created by dinhphong on 8/30/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import UIKit
import GooglePlacePicker



class FilterWorkController: BaseViewController {
    
    let cellId = "cellId"
    
    lazy var tableFilterWork: UITableView = {
        let tbv = UITableView()
        tbv.translatesAutoresizingMaskIntoConstraints = false
        tbv.backgroundColor = .clear
        tbv.separatorStyle = .singleLine
        tbv.isScrollEnabled = false
        tbv.dataSource = self
        tbv.delegate = self
        return tbv
    }()
    
    private let updateButton : UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Cập nhật", for: .normal)
        btn.backgroundColor = UIColor(red: 51/255, green: 197/255, blue: 205/255, alpha: 1)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        title = "Tìm kiếm nâng cao"
        setupView()
        
        tableFilterWork.register(FilterControllCell.self, forCellReuseIdentifier: cellId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setupView() {
        self.view.addSubview(tableFilterWork)
        self.view.addSubview(updateButton)
        
        view.addConstraintWithFormat(format: "H:|[v0]|", views: tableFilterWork)
        view.addConstraintWithFormat(format: "V:|[v0(132)]-20-[v1(45)]", views: tableFilterWork, updateButton)
        
        updateButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        updateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
    }
}

extension FilterWorkController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! FilterControllCell
        switch indexPath.item {
        case 0:
            cell.title = "Vị trí"
            cell.status = "Hiện tại"
        case 1:
            cell.title = "Khoảng cách"
            cell.status = "3 km"
        case 2:
            cell.title = "Loại công việc"
            cell.status = "Sửa chữa điện nước"
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(LocationViewController(), animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
}
