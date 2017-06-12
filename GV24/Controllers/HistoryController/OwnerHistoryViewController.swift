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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.allowsSelection = false
        tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0)
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.register(UINib(nibName:"OwnerHistoryViewCell",bundle:nil), forCellReuseIdentifier: "OwnerHistoryCell")
        self.activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        self.tableView.backgroundView = self.activityIndicatorView
        getOwnerList(startAt: nil, endAt: Date())
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Chủ nhà đã làm"
        segment.selectedSegmentIndex = 1
    }
    
    override func setupViewBase() {
        super.setupViewBase()
    }
    
    override func decorate() {
        
    }
    
    /* /maid/getAllWorkedOwner
     params: startAt, endAt
     */
    func getOwnerList(startAt: Date?, endAt: Date) {
        self.activityIndicatorView.startAnimating()
        var params: [String: Any] = [:]
        if startAt != nil {
            params["startAt"] = String.convertDateToISODateType(date: startAt!)
        }
        params["endAt"] = String.convertDateToISODateType(date: endAt)
        let headers: HTTPHeaders = ["hbbgvauth": UserDefaultHelper.getToken()!]
        OwnerServices.sharedInstance.getOwnerList(url: APIPaths().urlGetOwnerList(), param: params, header: headers) { (data, err) in
            if err == nil {
                if data != nil {
                    self.ownerList.append(contentsOf: data!)
                    DispatchQueue.main.async {
                        self.activityIndicatorView.stopAnimating()
                        self.tableView.reloadData()
                    }
                }
            }
            else {
                print("Error occurred while getting owner list in OwnerHistoryViewController.")
            }
        }
    }
    
    fileprivate func configureOwnerCell(cell: OwnerHistoryViewCell, indexPath: IndexPath) {
        let owner = ownerList[indexPath.item]
        if let imageString = owner.image {
            let url = URL(string: imageString)
            cell.userImage.kf.setImage(with: url, placeholder: UIImage(named: "nau an"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        cell.userName.text = owner.name
        cell.dateLabel.text = String.convertISODateToString(isoDateStr: (owner.workTime.first)!, format: "dd/MM/yyyy")
        cell.workListButton.tag = indexPath.item
        cell.workListButton.addTarget(self, action: #selector(OwnerHistoryViewController.btnClicked(sender:)), for: UIControlEvents.touchUpInside)
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
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.colorWithRedValue(redValue: 237, greenValue: 236, blueValue: 243, alpha: 1)
        return footerView
    }
}
