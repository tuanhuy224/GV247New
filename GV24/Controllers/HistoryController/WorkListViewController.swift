//
//  WorkListViewController.swift
//  GV24
//
//  Created by admin on 6/9/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import SwiftyJSON

class WorkListViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var list:[Work] = []
    var owner: Owner?
    var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(WorkListViewController.updateOwnerList), for: UIControlEvents.valueChanged)
        return refresh
    }()
    var activityIndicatorView: UIActivityIndicatorView = {
        return UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    }()
    var page: Int = 1
    var limit: Int = 10
    
    lazy var emptyLabel: UILabel = {
       return TableViewHelper().emptyMessage(message: "", size: self.tableView.bounds.size)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        getTaskOfOwner()
    }
    
    func setupTableView() {
        self.automaticallyAdjustsScrollViewInsets = false
        let nib = UINib(nibName: NibHistoryViewCell, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: HistoryViewCellID)
        self.tableView.addSubview(self.refreshControl)
        self.tableView.backgroundView = self.activityIndicatorView
    }
    
    @objc fileprivate func updateOwnerList(){
        self.refreshControl.endRefreshing()
        self.page = 1
        self.list.removeAll()
        self.tableView.reloadData()
        self.getTaskOfOwner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "WorkList".localize//"Danh sách công việc"
    }

    override func setupViewBase() {}
    
    override func decorate() {
    }
    
    fileprivate func setTableViewMessage(result:ResultStatus) {
        self.emptyLabel.text = result.rawValue
        self.tableView.backgroundView = self.emptyLabel
        self.tableView.separatorStyle = .none
    }
    
    /*  GET: /maid/getTaskOfOwner owner: ownerId
     startAt, endAt (opt): ISODate
     page, limit (opt): number (int)
     */
    fileprivate func getTaskOfOwner() {
        self.tableView.backgroundView = self.activityIndicatorView
        self.activityIndicatorView.startAnimating()
        var params:[String:Any] = [:]
        params["owner"] = "\((owner?.id)!)"
        params["page"] = self.page
        params["limit"] = self.limit
        let headers: HTTPHeaders = ["hbbgvauth": "\(UserDefaultHelper.getToken()!)"]
        HistoryServices.sharedInstance.getListWith(object: Work(), url: APIPaths().urlGetTaskOfOwner(), param: params, header: headers) { (data, error) in
            switch error {
            case .Success:
                self.list.append(contentsOf: data!)
                self.tableView.separatorStyle = .singleLine
                break
            case .EmptyData:
                self.setTableViewMessage(result: .EmptyData)
                break
            default:
                self.setTableViewMessage(result: .Unauthorize)
                break
            }
            DispatchQueue.main.async {
                self.activityIndicatorView.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
    
    func configureCell(cell: HistoryViewCell, indexPath: IndexPath) {
        if list.count != 0 {
            let work = list[indexPath.item]
            
            if let imageString = work.info?.workName?.image {
                let url = URL(string: imageString)
                cell.imageWork.kf.setImage(with: url, placeholder: UIImage(named: "nau an"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            
            cell.lbDeadline.isHidden = true
            cell.workNameLabel.text = work.info?.title
            
            let startAt = work.workTime?.startAt
            let startAtString = String(describing: startAt!)
            let endAt = work.workTime?.endAt
            let endAtString = String(describing: endAt!)
            
            cell.createdDate.text = String.convertISODateToString(isoDateStr: startAtString, format: "dd/MM/yyyy")
            
            cell.lbTimePost.text = "\(Date().dateComPonent(datePost: (work.workTime?.startAt)!))"
            cell.timeWork.text = String.convertISODateToString(isoDateStr: startAtString, format: "HH:mm a")! + " - " + String.convertISODateToString(isoDateStr: endAtString, format: "HH:mm a")!
            cell.lbDist.text = "CompletedWork".localize
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == list.count - 1 {
            self.page = self.page + 1
            self.getTaskOfOwner()
        }
    }
}

extension WorkListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryViewCellID, for: indexPath) as! HistoryViewCell
        self.configureCell(cell: cell, indexPath: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = FinishedWorkViewController()
        vc.work = list[indexPath.item]
        vc.isWorkListComing = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension WorkListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

