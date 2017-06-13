//
//  OwnerHistoryViewController.swift
//  GV24
//
//  Created by admin on 6/5/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class OwnerHistoryViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    var ownerList:[Owner] = []
    var myParent: ManagerHistoryViewController?
    var activityIndicatorView:UIActivityIndicatorView!
    
    @IBOutlet weak var segment: UISegmentedControl!
    var refreshControl: UIRefreshControl!
    var startAtDate: Date? = nil
    var endAtDate: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.allowsSelection = false
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 0.01))
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(OwnerHistoryViewController.updateOwnerList), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(self.refreshControl)
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.register(UINib(nibName:"OwnerHistoryViewCell",bundle:nil), forCellReuseIdentifier: "OwnerHistoryCell")
        self.activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        self.tableView.backgroundView = self.activityIndicatorView
        getOwnerList(startAt: startAtDate, endAt: endAtDate)
    }
    
    @objc fileprivate func updateOwnerList(){
        self.refreshControl.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Chủ nhà đã làm"
    }
    
    override func setupViewBase() {
        super.setupViewBase()
    }
    
    override func decorate() {}
    
    /* /maid/getAllWorkedOwner
     params: startAt, endAt
     */
    func getOwnerList(startAt: Date?, endAt: Date) {
        self.activityIndicatorView.startAnimating()
        var params: [String: Any] = [:]
        if startAt != nil {
            params["startAt"] = "\(String.convertDateToISODateType(date: startAt!)!)"
        }
        params["endAt"] = "\(String.convertDateToISODateType(date: endAt)!)"
        let headers: HTTPHeaders = ["hbbgvauth": UserDefaultHelper.getToken()!]
        OwnerServices.sharedInstance.getOwnersList(url: APIPaths().urlGetOwnerList(), param: params, header: headers) { (data, err) in
            if err == nil {
                if data != nil {
                    self.ownerList.append(contentsOf: data!)
                    DispatchQueue.main.async {
                        self.activityIndicatorView.stopAnimating()
                        self.tableView.backgroundView = nil
                        self.tableView.reloadData()
                    }
                }
            }
            else {
                print("Error occurred while getting owner list in OwnerHistoryViewController.")
                self.activityIndicatorView.stopAnimating()
            }
        }
    }
    
    fileprivate func configureOwnerCell(cell: OwnerHistoryViewCell, indexPath: IndexPath) {
        if ownerList.count != 0 {
            let owner = ownerList[indexPath.item]
            if let imageString = owner.image {
                let url = URL(string: imageString)
                cell.userImage.kf.setImage(with: url, placeholder: UIImage(named: "nau an"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            cell.userName.text = owner.name
            cell.dateLabel.text = String.convertISODateToString(isoDateStr: (owner.workTime.last)!, format: "dd/MM/yyyy")
            cell.workListButton.tag = indexPath.item
            cell.workListButton.addTarget(self, action: #selector(OwnerHistoryViewController.btnClicked(sender:)), for: UIControlEvents.touchUpInside)
        }
    }
    
    @objc fileprivate func btnClicked(sender: UIButton) {
        let vc = WorkListViewController()
        vc.owner = ownerList[sender.tag]
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        myParent?.navigationController?.pushViewController(vc, animated: true)
    }
}

extension OwnerHistoryViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return ownerList.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OwnerHistoryCell", for: indexPath) as! OwnerHistoryViewCell
        
        self.configureOwnerCell(cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension OwnerHistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
