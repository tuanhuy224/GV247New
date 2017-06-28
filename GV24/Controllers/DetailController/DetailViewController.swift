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
    var header:HTTPHeaders?
    var isStatus:Bool = false
    var idWork:String?
    var titleString:String?
    var works = Work()
    let aroundView:WorkAroundController = WorkAroundController(nibName: "WorkAroundController", bundle: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        tbDetail.register(UINib(nibName:NibWorkDetailCell,bundle:nil), forCellReuseIdentifier: workDetailCellID)
        tbDetail.register(UINib(nibName:NibInfoDetailCell,bundle:nil), forCellReuseIdentifier: infoDetailCellID)
        tbDetail.allowsSelection = false
        postRerves()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.tbDetail.reloadData()
        }
    }
    func loadData() {
        let headers: HTTPHeaders = ["hbbgvauth": "\(UserDefaultHelper.getToken()!)"]
        let parameter:Parameters = ["id":"\(UserDefaultHelper.getString()!)"]
        APIService.shared.getUrl(url: APIPaths().taskGetById(), param: parameter, header: headers) { (json, error) in
        }
    }
    override func setupViewBase() {
        self.title = titleString
        tbDetail.reloadData()
    }
    func postRerves(){
        let apiService = APIService.shared
        let parameter:Parameters = ["id":idWork!]
            header = ["Content-Type":"application/x-www-form-urlencoded","hbbgvauth":"\(UserDefaultHelper.getToken()!)"]
            apiService.postReserve(url: APIPaths().urlReserve(), method: .post, parameters: parameter, header: header!) { (json, error) in
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
            cell.ownerDelegate = self
            cell.delegateWork = self
            cell.constraintHeightButtonChoose.constant = 28
            cell.btChoose.isHidden = false
            cell.vSegment.isHidden = false
            cell.nameUser.text = works.stakeholders?.owner?.username
            cell.addressName.text = works.stakeholders?.owner?.address?.name
            DispatchQueue.main.async {
                cell.imageName.kf.setImage(with:URL(string: self.works.stakeholders!.owner!.image!))
            }
            return cell
        }else{
            let cell:InfoDetailCell = tbDetail.dequeueReusableCell(withIdentifier: "infoDetailCell", for: indexPath) as! InfoDetailCell
            DispatchQueue.main.async {
                cell.lbTitle.text = self.works.info?.title
                cell.lbSubTitle.text = self.works.info?.content
                cell.lbMoney.text = "\(self.works.info!.salary!)\(" Dollar".localize)"
                cell.lbComment.text = self.works.info?.content
                cell.lbAddress.text = self.works.info?.address?.name
                cell.lbDate.text = Date(isoDateString: (self.works.workTime!.endAt)!).dayMonthYear
                cell.lbTime.text = String.convertISODateToString(isoDateStr: (self.works.workTime!.startAt)!, format: "HH:mm a")! + " - " + String.convertISODateToString(isoDateStr: (self.works.workTime!.endAt)!, format: "HH:mm a")!
            }
            return cell
        }
    }
}
extension DetailViewController:UITableViewDelegate{

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        }else{
            return 276
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
extension DetailViewController:clickChooseWorkID,UIAlertViewDelegate{
    func chooseAction() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let parameter = ["id":idWork!]
        print(idWork!)
        let header = ["hbbgvauth":"\(UserDefaultHelper.getToken()!)"]
        let apiClient = APIService.shared
        apiClient.postReserve(url: APIPaths().urlReserve(), method: .post, parameters: parameter, header: header) { (json, string) in
            let alertC = AlertStandard.sharedInstance
            MBProgressHUD.hide(for: self.view, animated: true)
            alertC.showAlertCt(controller: self, pushVC: ManageViewController(), title: "", message: "Dothiswork".localize)
            
        }
    }
}
extension DetailViewController:chooseWorkDelegate{
    func detailManagementDelegate(){
    
    }
}
extension DetailViewController:OwnerDelegate{
    func chooseActionOwner() {
        let navi = DetailOwnerViewController(nibName: "DetailOwnerViewController", bundle: nil)
        navi.owner = works
        navigationController?.pushViewController(navi, animated: true)
    }
}

