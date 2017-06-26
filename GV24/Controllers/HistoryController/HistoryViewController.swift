//
//  HistoryViewController.swift
//  GV24
//
//  Created by HuyNguyen on 5/29/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class HistoryViewController: BaseViewController {
    
    var user:User?
    var workList: [Work] = []
    var myParent: ManagerHistoryViewController?
    var page: Int = 1
    var limit: Int = 10
    var startAtDate: Date? = nil
    var endAtDate: Date = Date()
    
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var segmentContainer: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var fromDateContainer: UIView!
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
       return UIActivityIndicatorView(activityIndicatorStyle: .gray)
    }()
    lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(HistoryViewController.updateOwnerList), for: UIControlEvents.valueChanged)
        return refresh
    }()
    
    lazy var emptyLabel: UILabel = {
        return TableViewHelper().emptyMessage(message: "", size: self.historyTableView.bounds.size)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        getWorkList(startAt: startAtDate, endAt: endAtDate)
    }
    
    func setupTableView() {
        historyTableView.register(UINib(nibName: NibHistoryViewCell,bundle:nil), forCellReuseIdentifier: historyCellID)
        self.automaticallyAdjustsScrollViewInsets = false
        historyTableView.tableFooterView = UIView()
        self.historyTableView.addSubview(self.refreshControl)
        historyTableView.backgroundView = self.activityIndicatorView
        historyTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: historyTableView.bounds.size.width, height: 0.01))
        self.historyTableView.separatorStyle = .singleLine
    }
    
    func updateOwnerList() {
        self.refreshControl.endRefreshing()
        self.page = 1
        self.workList.removeAll()
        self.historyTableView.reloadData()
        self.getWorkList(startAt: startAtDate, endAt: endAtDate)
    }
    
    override func decorate() {}
    
    override func setupViewBase() {}
    
    /* /maid/getHistoryTasks
     Params: startAt (opt), endAt (opt): ISO Date, page, limit: Number
     */
    func getWorkList(startAt: Date?, endAt: Date) {
        self.historyTableView.backgroundView = self.activityIndicatorView
        self.activityIndicatorView.startAnimating()
        user = UserDefaultHelper.currentUser
        var params:[String:Any] = [:]
        if startAt != nil {
            params["startAt"] = "\(String.convertDateToISODateType(date: startAt!)!)"
        }
        params["endAt"] = "\(String.convertDateToISODateType(date: endAt)!)"
        params["page"] = self.page
        params["limit"] = self.limit
        let headers: HTTPHeaders = ["hbbgvauth": "\(UserDefaultHelper.getToken()!)"]
        HistoryServices.sharedInstance.getListWith(object: Work(), url: APIPaths().urlGetWorkListHistory(), param: params, header: headers) { (data, err) in
            switch err{
            case .Success:
                self.workList.append(contentsOf: data!)
                self.historyTableView.backgroundView?.isHidden = true
                break
            case .EmptyData:
                let emptyView = TableViewHelper().noData(frame: CGRect(x: self.historyTableView.center.x, y: self.historyTableView.center.y, width: self.historyTableView.frame.size.width, height: self.historyTableView.frame.size.height))
                self.historyTableView.backgroundView = emptyView
                self.historyTableView.backgroundView?.isHidden = false
                break
            default:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "unauthorized"), object: nil)
                self.historyTableView.backgroundView?.isHidden = true
                break
            }
            DispatchQueue.main.async {
                self.activityIndicatorView.stopAnimating()
                self.historyTableView.reloadData()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "WorkHistory".localize//"Lịch sự công việc"
    }
    fileprivate func configureCell(cell: HistoryViewCell, indexPath: IndexPath) {
        let work = workList[indexPath.item]
        if let imageString = work.info?.workName?.image {
            let url = URL(string: imageString)
            cell.imageWork.kf.setImage(with: url, placeholder: UIImage(named: "nau an"), options: nil, progressBlock: nil, completionHandler: nil)
            cell.lbDeadline.isHidden = true
        }

        cell.lbDeadline.isHidden = true

        cell.workNameLabel.text = work.info?.title
        let startAt = work.workTime?.startAt
        let startAtString = String(describing: startAt!)
        let endAt = work.workTime?.endAt
        let endAtString = String(describing: endAt!)
        cell.timeWork.text = String.convertISODateToString(isoDateStr: startAtString, format: "HH:mm a")! + " - " + String.convertISODateToString(isoDateStr: endAtString, format: "HH:mm a")!
         cell.lbTimePost.text = "\(Date().dateComPonent(datePost: (work.workTime?.startAt)!))"
        cell.lbDist.text = "CompletedWork".localize
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.workList.count - 1 {
            self.page = self.page + 1
            self.getWorkList(startAt: self.startAtDate, endAt: self.endAtDate)
        }
    }
}
extension HistoryViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = historyTableView.dequeueReusableCell(withIdentifier: historyCellID, for: indexPath) as! HistoryViewCell
        self.configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = FinishedWorkViewController()
        vc.work = workList[indexPath.item]
        let backItem = UIBarButtonItem()
        backItem.title = "Back".localize
        navigationItem.backBarButtonItem = backItem
        _ = myParent?.navigationController?.pushViewController(vc, animated: true)
    }
}
extension HistoryViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
