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
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        // configure
        indicator.hidesWhenStopped = true
        return indicator
    }()
    lazy var emptyLabel: UILabel = {
        let label = TableViewHelper().emptyMessage(message: "", size: CGSize(width: 200, height: 100))
        label.textColor = UIColor.colorWithRedValue(redValue: 109, greenValue: 108, blueValue: 113, alpha: 1)
        
        label.isHidden = true
        return label
    }()
    lazy var emptyDataView: UIView = {
        let emptyView = TableViewHelper().noData(frame: CGRect(x: self.view.frame.size.width/2 - 50, y: 50, width: 100, height: 150))
        emptyView.isHidden = true
        return emptyView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupLoadingIndicator()
        setupEmptyDataView()
        setupEmptyLabel()

        getOwnerList(startAt: startAtDate, endAt: endAtDate)
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName:NibOwnerHistoryViewCell,bundle:nil), forCellReuseIdentifier: ownerHistoryCellID)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 0.01))
        self.tableView.addSubview(self.refreshControl)
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.backgroundView = self.activityIndicatorView
    }
    
    func setupLoadingIndicator() {
        view.addSubview(activityIndicatorView)
        activityIndicatorView.center = view.center
    }
    
    func setupEmptyDataView() {
        view.addSubview(emptyDataView)
    }
    
    func setupEmptyLabel(){
        view.addSubview(emptyLabel)
        emptyLabel.frame = CGRect(x: self.view.frame.size.width/2 - 100, y: 0, width: 200, height: 100)
    }
    
    func showLoadingIndicator() {
        if !self.refreshControl.isRefreshing {
            self.activityIndicatorView.startAnimating()
        }
    }
    
    func hideLoadingIndicator() {
        self.activityIndicatorView.stopAnimating()
    }

    
    func updateUI(status: ResultStatus) {
        switch status {
        case .Success:
            //self.tableView.isHidden = false
            self.emptyDataView.isHidden = true
            self.emptyLabel.isHidden = true
        case .EmptyData:
            //self.tableView.isHidden = true
            self.emptyDataView.isHidden = false
            self.emptyLabel.isHidden = true
            break
        case .LostInternet:
            self.emptyLabel.text = "NetworkIsLost".localize
            //self.tableView.isHidden = true
            self.emptyDataView.isHidden = true
            self.emptyLabel.isHidden = false
        default:
            self.emptyLabel.text = "TimeoutExpiredPleaseLoginAgain".localize
            //self.tableView.isHidden = true
            self.emptyDataView.isHidden = true
            self.emptyLabel.isHidden = false
            break
        }
        self.tableView.reloadData()
    }

    
    @objc fileprivate func updateOwnerList(){
        self.refreshControl.beginRefreshing()
        self.ownerList.removeAll()
        self.tableView.reloadData()
        self.getOwnerList(startAt: startAtDate, endAt: endAtDate)
        self.refreshControl.endRefreshing()
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
        self.ownerList.removeAll()
        self.tableView.reloadData()
        self.showLoadingIndicator()
        var params: [String: Any] = [:]
        if startAt != nil {
            params["startAt"] = "\(String.convertDateToISODateType(date: startAt!)!)"
        }
        params["endAt"] = "\(String.convertDateToISODateType(date: endAt)!)"
        let headers: HTTPHeaders = ["hbbgvauth": UserDefaultHelper.getToken()!]
        OwnerServices.sharedInstance.getOwnersList(url: APIPaths().urlGetOwnerList(), param: params, header: headers) { (data, status) in
            let stat: ResultStatus = (self.net?.isReachable)! ? status : .LostInternet
            
            if stat == .Success {
                self.ownerList =  data!
            }
            DispatchQueue.main.async {
                self.updateUI(status: stat)
                self.hideLoadingIndicator()
            }
        }
    }
    
    fileprivate func configureOwnerCell(cell: OwnerHistoryViewCell, indexPath: IndexPath) {
        if ownerList.count != 0 {
            let owner = ownerList[indexPath.section]
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
        let vc = DetailManagementController()
        let owner = ownerList[indexPath.section]
        vc.workPending = owner.convertToWork(owner: owner)
        _ = myParent?.navigationController?.pushViewController(vc, animated: true)
    }
}
extension OwnerHistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
