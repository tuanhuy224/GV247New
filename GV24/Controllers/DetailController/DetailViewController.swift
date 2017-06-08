//
//  DetailViewController.swift
//  GV24
//
//  Created by HuyNguyen on 6/2/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Alamofire

class DetailViewController: BaseViewController {
    @IBOutlet weak var tbDetail: UITableView!
    var id:String?
    let aroundView:WorkAroundController = WorkAroundController(nibName: "WorkAroundController", bundle: nil)
    let url = "https://yukotest123.herokuapp.com/en/task/getById"
    override func viewDidLoad() {
        super.viewDidLoad()
        tbDetail.register(UINib(nibName:"WorkDetailCell",bundle:nil), forCellReuseIdentifier: "workDetailCell")
        tbDetail.register(UINib(nibName:"InfoDetailCell",bundle:nil), forCellReuseIdentifier: "infoDetailCell")
        tbDetail.allowsSelection = false
        DispatchQueue.main.async {
            self.loadData()
        }
    }
    func loadData() {
        let headers: HTTPHeaders = ["hbbgvauth": "\(UserDefaultHelper.getToken()!)"]
        let parameter:Parameters = ["id":"\(UserDefaultHelper.getString()!)"]
        APIService.shared.getUrl(url: url, param: parameter, header: headers) { (json, error) in
            print(json as Any)
        }
    }

}

extension DetailViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell:WorkDetailCell = tbDetail.dequeueReusableCell(withIdentifier: "workDetailCell", for: indexPath) as! WorkDetailCell
            return cell
        }else{
            let cell:InfoDetailCell = tbDetail.dequeueReusableCell(withIdentifier: "infoDetailCell", for: indexPath) as! InfoDetailCell
            return cell
        }
        
    }
}
extension DetailViewController:UITableViewDelegate{

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 80
        }else{
            return 276
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
