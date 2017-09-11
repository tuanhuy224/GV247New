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
    @IBOutlet weak var btSelect: UIButton!
    @IBOutlet weak var vSelect: UIView!
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
        self.title = "selectwork".localize
        btSelect.setTitle("Selectthiswork".localize, for: .normal)
        btSelect.layer.cornerRadius = 4
        btSelect.clipsToBounds = true
        btSelect.tintColor = .white
        btSelect.backgroundColor = UIColor.colorButton
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
    
    
    @IBAction func btSelectAction(_ sender: UIButton) {
            guard let id = works.id else{return}
            guard let token = UserDefaultHelper.getToken() else{
                //return AlertStandard.sharedInstance.showAlertCt(controller: self, pushVC: LoginView(), title: "", message: "Pleasesign".localize)
                
                return AlertStandard.sharedInstance.showAlertCt(controller: self, pushVC: nil, title: "", message: "Pleasesign".localize, completion: {
                    guard let window = UIApplication.shared.keyWindow else{return}
                    let navi = UINavigationController(rootViewController: LoginView())
                    window.rootViewController = navi
                })
            }
            let parameter = ["id":id]
            let header = ["hbbgvauth":token]
            let apiClient = APIService.shared
            AlertStandard.sharedInstance.showAlertCt(controller: self, pushVC: nil, title: "", message: "Dothiswork".localize) {
                self.loadingView.show()
                apiClient.postReserve(url: APIPaths().urlReserve(), method: .post, parameters: parameter, header: header) { (json, string) in
                    self.loadingView.close()
                    if string == "RESERVE_EXIST"{
                        AlertStandard.sharedInstance.showAlert(controller: self, title: "", message: "Workcurrentlychosen".localize)
                    }
                    AlertStandard.sharedInstance.showAlert(controller: self, title: "", message: "Workchosensuccessfully".localize)
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
            cell.lbOwner.text = "ownerInfor".localize
            cell.btChoose.isHidden = true
            cell.vSegment.isHidden = true
            cell.heightBtChoose.constant = 0
            cell.constraintH.constant = 0
            cell.btChooseConstraint.constant = 0
            cell.btChoose.setTitle("Selectthiswork".localize, for: .normal)
            cell.nameUser.text = works.stakeholders?.owner?.name
            cell.addressName.text = works.stakeholders?.owner?.address?.name
            let url = URL(string: self.works.stakeholders!.owner!.image!)
            if url == nil {
                cell.imageName.image = UIImage(named: "avatar")
            }else{
                DispatchQueue.main.async {
                    cell.imageName.kf.setImage(with: url, placeholder: UIImage(named: "avatar"), options: nil, progressBlock: nil, completionHandler: nil)
                }
            }
            return cell
        }else{
            let cell:InfoDetailCell = tbDetail.dequeueReusableCell(withIdentifier: "infoDetailCell", for: indexPath) as! InfoDetailCell
            cell.lbTitle.text = self.works.info?.title
            cell.lbDescription.text = "Description".localize
            cell.lbSubTitle.text = self.works.info?.workName?.name

            let salary = self.works.info?.salary
            if salary == 0 {
                cell.lbMoney.text = "Timework".localize
            }else{
                
                cell.lbMoney.text = String().numberFormat(number: salary ?? 0) + " " + "VND"
            }
            cell.lbComment.text = self.works.info?.content
            cell.lbAddress.text = self.works.info?.address?.name
            let url = URL(string: self.works.info!.workName!.image!)
            if url == nil {
                cell.imageAvatar.image = UIImage(named: "avatar")
            }else{
                DispatchQueue.main.async {
                    cell.imageAvatar.kf.setImage(with:url)
                }
            }
            let tool = works.info?.tools
            if  tool == true {
                cell.lbTools.isHidden = false
                cell.lbTools.text = "Bringyourcleaningsupplies".localize
            }
            cell.lbDate.text = Date(isoDateString: (self.works.workTime!.endAt)!).dayMonthYear
            cell.lbTime.text = Date(isoDateString: (works.workTime?.startAt)!).hourMinute + " - " + Date(isoDateString: (works.workTime?.endAt)!).hourMinute
            return cell
        }
    }
}
extension DetailViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            let navi = DetailManagementController(nibName: "DetailManagementController", bundle: nil)
            navi.workPending = works
            navigationController?.pushViewController(navi, animated: true)
        }else{
            
        }
    }
}
extension DetailViewController:clickChooseWorkID,UIAlertViewDelegate{
    func chooseAction() {
        guard let id = works.id else{return}
        guard let token = UserDefaultHelper.getToken() else{
            //return AlertStandard.sharedInstance.showAlertCt(controller: self, pushVC: LoginView(), title: "", message: "Pleasesign".localize)
            
            return AlertStandard.sharedInstance.showAlertCt(controller: self, pushVC: nil, title: "", message: "Pleasesign".localize, completion: {
                guard let window = UIApplication.shared.keyWindow else{return}
                let navi = UINavigationController(rootViewController: LoginView())
                window.rootViewController = navi
            })
        }
        let parameter = ["id":id]
        let header = ["hbbgvauth":token]
        let apiClient = APIService.shared
        AlertStandard.sharedInstance.showAlertCt(controller: self, pushVC: nil, title: "", message: "Dothiswork".localize) {
            self.loadingView.show()
            apiClient.postReserve(url: APIPaths().urlReserve(), method: .post, parameters: parameter, header: header) { (json, string) in
                self.loadingView.close()
                if string == "RESERVE_EXIST"{
                    AlertStandard.sharedInstance.showAlert(controller: self, title: "", message: "Workcurrentlychosen".localize)
                }
                AlertStandard.sharedInstance.showAlert(controller: self, title: "", message: "Workchosensuccessfully".localize)
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

