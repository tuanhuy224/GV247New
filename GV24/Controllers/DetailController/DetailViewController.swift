//
//  DetailViewController.swift
//  GV24
//
//  Created by HuyNguyen on 6/2/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class DetailViewController: BaseViewController {
    @IBOutlet weak var tbDetail: UITableView!
    var id:String?
    var isStatus:Bool = false
    var idWork:String?
    var titleString:String?
    var works = [Work]()
    let aroundView:WorkAroundController = WorkAroundController(nibName: "WorkAroundController", bundle: nil)
    let url = "https://yukotest123.herokuapp.com/en/task/getById"
    override func viewDidLoad() {
        super.viewDidLoad()
        tbDetail.register(UINib(nibName:"WorkDetailCell",bundle:nil), forCellReuseIdentifier: "workDetailCell")
        tbDetail.register(UINib(nibName:"InfoDetailCell",bundle:nil), forCellReuseIdentifier: "infoDetailCell")
        tbDetail.allowsSelection = false
        postRerves()
    }
    func loadData() {
        let headers: HTTPHeaders = ["hbbgvauth": "\(UserDefaultHelper.getToken()!)"]
        let parameter:Parameters = ["id":"\(UserDefaultHelper.getString()!)"]
        APIService.shared.getUrl(url: url, param: parameter, header: headers) { (json, error) in
            print(json as Any)
        }
    }
    override func setupViewBase() {
        self.title = titleString
    }
    func postRerves(){
        let apiService = APIService.shared
        let parameter:Parameters = ["id":idWork!]
        let header = ["Content-Type":"application/x-www-form-urlencoded","hbbgvauth":"\(UserDefaultHelper.getToken()!)"]
        apiService.postReserve(url: urlReserve, method: .post, parameters: parameter, header: header) { (json, error) in
            if json == "SUCCESS"{
                self.isStatus = true
            }
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
            cell.delegate = self
            cell.nameUser.text = works[indexPath.row].stakeholders?.owner?.username
            cell.addressName.text = works[indexPath.row].stakeholders?.owner?.address?.name
            DispatchQueue.main.async {
                cell.imageName.kf.setImage(with:URL(string: self.works[indexPath.row].stakeholders!.owner!.image!))
            }
            return cell
        }else{
            let cell:InfoDetailCell = tbDetail.dequeueReusableCell(withIdentifier: "infoDetailCell", for: indexPath) as! InfoDetailCell
            cell.lbTitle.text = works[indexPath.row].info?.title
            cell.lbSubTitle.text = works[indexPath.row].info?.content
            cell.lbMoney.text = "\(works[indexPath.row].info!.salary!)\(" Dollar".localize)"
            cell.lbComment.text = works[indexPath.row].info?.content
            cell.lbAddress.text = works[indexPath.row].info?.address?.name
            cell.lbDate.text = Date(isoDateString: (works[indexPath.row].workTime!.endAt)!).dayMonthYear
            cell.lbTime.text = "\(Date(isoDateString: (works[indexPath.row].workTime!.startAt)!).hourMinute) \("-") \(Date(isoDateString: (works[indexPath.row].workTime!.endAt)!).hourMinute)"
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
extension DetailViewController:chooseWorkDelegate{
    func chooseAction() {
        if isStatus == true {
            navigationController?.pushViewController(ManageViewController(), animated: true)
        }else{
        print("111")
        }
    }
}
