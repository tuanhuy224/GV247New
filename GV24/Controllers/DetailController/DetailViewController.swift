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
        //postRerves()
        self.tbDetail.rowHeight = UITableViewAutomaticDimension
        self.tbDetail.estimatedRowHeight = 100.0
    }
    func loadData() {
        let headers: HTTPHeaders = ["hbbgvauth": "\(UserDefaultHelper.getToken()!)"]
        let parameter:Parameters = ["id":"\(UserDefaultHelper.getString()!)"]
        APIService.shared.getUrl(url: APIPaths().taskGetById(), param: parameter, header: headers) { (json, error) in
        }
    }
    override func setupViewBase() {
        self.title = titleString
        //tbDetail.reloadData()
    }
    func postRerves(){
        let apiService = APIService.shared
        guard let token = UserDefaultHelper.getToken() else{return}
        guard let id = idWork else{return}
        let parameter:Parameters = ["id":id]
            header = ["Content-Type":"application/x-www-form-urlencoded","hbbgvauth":token]
            apiService.postReserve(url: APIPaths().urlReserve(), method: .post, parameters: parameter, header: header!) { (json, error) in
                if json == "SUCCESS"{
                    //self.isStatus = true
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
            cell.btChoose.isHidden = false
            cell.vSegment.isHidden = false
            cell.btChoose.setTitle("Selectthiswork".localize, for: .normal)
            cell.nameUser.text = works.stakeholders?.owner?.name
            cell.addressName.text = works.stakeholders?.owner?.address?.name
            let url = URL(string: self.works.stakeholders!.owner!.image!)
            if url == nil {
                cell.imageName.image = UIImage(named: "avatar")
            }else{
                DispatchQueue.main.async {
                    cell.imageName.kf.setImage(with:url)
                }
            }
            return cell
        }else{
            let cell:InfoDetailCell = tbDetail.dequeueReusableCell(withIdentifier: "infoDetailCell", for: indexPath) as! InfoDetailCell
            DispatchQueue.main.async {
                cell.lbTitle.text = self.works.info?.title
                cell.lbSubTitle.text = self.works.info?.workName?.name
                cell.lbMoney.text = "\(self.works.info!.salary!)\("Dollar".localize)"
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let navi = DetailManagementController(nibName: "DetailManagementController", bundle: nil)
        navi.workPending = works
        navigationController?.pushViewController(navi, animated: true)
    }
}
extension DetailViewController:clickChooseWorkID,UIAlertViewDelegate{
    func chooseAction() {
      guard let id = idWork else{return}
      guard let token = UserDefaultHelper.getToken() else{return}
      let parameter = ["id":id]
      let header = ["hbbgvauth":token]
      let apiClient = APIService.shared
      AlertStandard.sharedInstance.showAlertCt(controller: self, pushVC: nil, title: "", message: "Dothiswork".localize) {
        self.loadingView.show()
        apiClient.postReserve(url: APIPaths().urlReserve(), method: .post, parameters: parameter, header: header) { (json, string) in
          self.loadingView.close()
        }
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

