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
    
    @IBOutlet weak var segment: UISegmentedControl!
    var startAtDate: Date? = nil
    var endAtDate: Date = Date()
    
    var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(OwnerHistoryViewController.updateOwnerList), for: UIControlEvents.valueChanged)
        return refresh
    }()
    
    var activityIndicatorView = {
        return UIActivityIndicatorView(activityIndicatorStyle: .gray)
    }()
    
    lazy var emptyLabel: UILabel = {
       return TableViewHelper().emptyMessage(message: "", size: self.tableView.bounds.size)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        getOwnerList(startAt: startAtDate, endAt: endAtDate)
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName:NibOwnerHistoryViewCell,bundle:nil), forCellReuseIdentifier: ownerHistoryCellID)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 0.01))
        self.tableView.addSubview(self.refreshControl)
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.backgroundView = self.activityIndicatorView
    }
    
    @objc fileprivate func updateOwnerList(){
        self.refreshControl.endRefreshing()
        self.ownerList.removeAll()
        self.tableView.reloadData()
        self.getOwnerList(startAt: startAtDate, endAt: endAtDate)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Owner".localize//"Chủ nhà đã làm"
    }
    
    override func setupViewBase() {
        super.setupViewBase()
    }
    
    override func decorate() {}
    
    /* /maid/getAllWorkedOwner
     params: startAt, endAt
     */
    func getOwnerList(startAt: Date?, endAt: Date) {
        self.tableView.backgroundView = self.activityIndicatorView
        self.activityIndicatorView.startAnimating()
        var params: [String: Any] = [:]
        if startAt != nil {
            params["startAt"] = "\(String.convertDateToISODateType(date: startAt!)!)"
        }
        params["endAt"] = "\(String.convertDateToISODateType(date: endAt)!)"
        let headers: HTTPHeaders = ["hbbgvauth": UserDefaultHelper.getToken()!]
        OwnerServices.sharedInstance.getOwnersList(url: APIPaths().urlGetOwnerList(), param: params, header: headers) { (data, err) in
            switch err {
            case .Success:
                self.ownerList.append(contentsOf: data!)
                self.tableView.backgroundView?.isHidden = true
                break
            case .EmptyData:
                let emptyView = TableViewHelper().noData(frame: CGRect(x: self.tableView.center.x, y: self.tableView.center.y, width: self.tableView.frame.size.width, height: self.tableView.frame.size.height))
                self.tableView.backgroundView = emptyView
                self.tableView.backgroundView?.isHidden = false
                break
            default:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "unauthorized"), object: nil)
                self.tableView.backgroundView?.isHidden = true
                break
            }
            DispatchQueue.main.async {
                self.activityIndicatorView.stopAnimating()
                self.tableView.reloadData()
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
            cell.workListButton.setTitle("WorkList".localize, for: .normal)
        }
    }
    
    @objc fileprivate func btnClicked(sender: UIButton) {
        let vc = WorkListViewController()
        vc.owner = ownerList[sender.tag]
        let backItem = UIBarButtonItem()
        backItem.title = "Back".localize
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
        let cell = tableView.dequeueReusableCell(withIdentifier: ownerHistoryCellID, for: indexPath) as! OwnerHistoryViewCell
        self.configureOwnerCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = InformationViewController()
        let owner = ownerList[indexPath.item]
        vc.user = owner.convertToUser()
        _ = myParent?.navigationController?.pushViewController(vc, animated: true)
    }
}
extension OwnerHistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
