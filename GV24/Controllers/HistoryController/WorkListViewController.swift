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
  var isLoading: Bool = false
  var current_page = 1
  var last_page = 1
  
  var list:[Work] = []{
    didSet{
    tableView.reloadData()
    }
  }
  var owner:Owner?
    lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
      refresh.addTarget(self, action: #selector(getTaskOfOwner), for: .valueChanged)
        return refresh
    }()

    
    lazy var emptyLabel: UILabel = {
        let label = TableViewHelper().emptyMessage(message: "", size: self.tableView.bounds.size)
        label.textColor = UIColor.colorWithRedValue(redValue: 109, greenValue: 108, blueValue: 113, alpha: 1)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        getTaskOfOwner()
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: NibHistoryViewCell, bundle: nil), forCellReuseIdentifier: HistoryViewCellID)
        tableView.addSubview(refreshControl)
        getTaskOfOwner()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.delegate = self
        tableView.dataSource = self
    }
  
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "WorkList".localize
    }

    override func setupViewBase() {}
    
    override func decorate() {
    }
    
    /*  GET: /maid/getTaskOfOwner owner: ownerId
     startAt, endAt (opt): ISODate
     page, limit (opt): number (int)
     */
    @objc fileprivate func getTaskOfOwner() {
      self.refreshControl.endRefreshing()
      guard !isLoading else { return }
      loadingView.show()
      self.isLoading = true
      guard let token = UserDefaultHelper.getToken() else{return}
      let headers: HTTPHeaders = ["hbbgvauth": token]
      guard let ownerId = owner?.id else{return}
      let params:[String:Any] = ["owner":ownerId]
      APIService.tasks(headers: headers, paramter: params) { (error: Error?, works: [Work]?, last_page: Int) in
        self.loadingView.close()
        self.isLoading = false
        if let work = works{
          self.list = work
          self.tableView.reloadData()
          self.current_page = 1
          self.last_page = last_page
        }
      }
    }
  
  fileprivate func loadMore() {
    
    guard !isLoading else { return }
    guard current_page < last_page else { return }
    loadingView.show()
    isLoading = true
    guard let token = UserDefaultHelper.getToken() else{return}
    let headers: HTTPHeaders = ["hbbgvauth": token]
    guard let ownerId = owner?.id else{return}
    let params:[String:Any] = ["owner":ownerId]
    APIService.tasks(page: current_page + 1,headers: headers, paramter: params) { (error: Error?, works: [Work]?, last_page: Int) in
     self.loadingView.close()
      self.isLoading = false
      if let work = works{
        self.list.append(contentsOf: work)
        self.tableView.reloadData()
        self.current_page += 1
        self.last_page = last_page
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
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension WorkListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let count = self.list.count
    
    if indexPath.row == count-1 {
      // last row
      self.loadMore()
    }
  }
}

