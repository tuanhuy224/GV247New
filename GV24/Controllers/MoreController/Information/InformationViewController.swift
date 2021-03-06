//
//  InformationViewController.swift
//  GV24
//
//  Created by HuyNguyen on 5/31/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import IoniconsSwift
import Kingfisher
import Alamofire

class InformationViewController: BaseViewController {
    let point = UserDefaultHelper.currentUser?.workInfor?.evaluation_point
    @IBOutlet weak var tbInformation: UITableView!
    var user:User?
    var page: Int = 1
    var limit: Int = 10
    var list: [Comment] = []
    var workTypeList: [WorkType] = []
    let imageFirst = Ionicons.androidStarOutline.image(32).maskWithColor(color: UIColor(red: 253/255, green: 179/255, blue: 53/255, alpha: 1))
    override func viewDidLoad() {
        super.viewDidLoad()
        tbInformation.register(UINib(nibName:NibInforCell,bundle:nil), forCellReuseIdentifier: inforCellID)
        tbInformation.register(UINib(nibName:NibInfoCommentCell,bundle:nil), forCellReuseIdentifier: infoCommentCellID)
        tbInformation.register(UINib(nibName: NibWorkInfoCell, bundle: nil), forCellReuseIdentifier: workInfoCellID)
        self.user = UserDefaultHelper.currentUser
        //customBarLeftButton()
        self.tbInformation.rowHeight = UITableViewAutomaticDimension
        self.tbInformation.estimatedRowHeight = 100.0
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(InformationViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        getOwnerComments()
        getWorkType()
    }
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        view.endEditing(true)
    }
    override func setupViewBase() {
        self.title = "Applicantprofile".localize
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func selectButton() {
        //navigationController?.pushViewController(DetailViewController(), animated: true)
    }
    
    func setImageAvatar(cell:UITableViewCell,imgView:UIImage) {
        let url = URL(string: (user?.image)!)
        let data = try? Data(contentsOf: url!)
        if let imageData = data {
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                cell.imageView?.image = image
            }
        }
    }
    /*
     /maid/getComment
     params: - id: userId
     */
    func getOwnerComments() {
        
        guard let id = self.user?.id else {return}
        
        var params:[String:Any] = [:]
        
        params["id"] = "\(id)"
        params["page"] = self.page
        params["limit"] = self.limit
        let headers: HTTPHeaders = ["hbbgvauth": "\(UserDefaultHelper.getToken()!)"]
        CommentServices.sharedInstance.getProfileCommentsWith(url: APIPaths().urlGetProfileComments(), param: params, header: headers) { (data, error) in
            switch error {
            case .Success:
                self.list.append(contentsOf: data!)
                break
            default:
                break
            }
            self.tbInformation.reloadData()
        }
    }
    
    /* https://yukotest123.herokuapp.com/vi/maid/getAbility
     no params
     */
    func getWorkType() {
        guard let token = UserDefaultHelper.getToken() else {return}
        let params: [String:Any] = [:]
        let header: HTTPHeaders = ["hbbgvauth":"\(token)"]
        HistoryServices.sharedInstance.getWorkAbility(url: APIPaths().urlGetWorkAbility(), param: params, header: header) { (data, err) in
            if (self.net?.isReachable)! {
                switch err{
                case .Success:
                    if self.page != 1{
                        self.workTypeList.append(contentsOf: data!)
                    }else {
                        self.workTypeList = data!
                    }
                    DispatchQueue.main.async {
                        let indexPath = IndexPath(item: 0, section: 1)
                        self.tbInformation.reloadRows(at: [indexPath], with: .fade)
                    }
                    break
                case .EmptyData:
                    DispatchQueue.main.async {
                        let alertController = AlertHelper().showAlertError(title: "Announcement".localize, message: "NoDataFound".localize)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    break
                default:
                    self.doTimeoutExpired()
                    break
                }
            }else {
                self.doNetworkIsDisconnected()
            }
        }
    }
    func doTimeoutExpired() {
        AlertStandard.sharedInstance.showAlert(controller: self, title: "Announcement".localize, message: "TimeoutExpiredPleaseLoginAgain".localize)
    }
    func doNetworkIsDisconnected() {
        AlertStandard.sharedInstance.showAlert(controller: self, title: "Announcement".localize, message: "NetworkIsLost".localize)
    }
    
    
    func InforCell(cell:InforCell) {
        let image = Ionicons.star.image(32).maskWithColor(color: UIColor(red: 253/255, green: 179/255, blue: 53/255, alpha: 1))
        guard let tag = point else {return}
        for i in cell.btRating!{
            if i.tag <= tag {
                i.setImage(image, for: .normal)
            }else{
                i.setImage(imageFirst, for: .normal)
            }
        }
    }
    
    
}
extension InformationViewController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return list.count
        }
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell:InforCell = (tbInformation.dequeueReusableCell(withIdentifier: inforCellID, for: indexPath) as? InforCell)!
            InforCell(cell: cell)
            if user?.gender == 0 {
                cell.lbGender.text = "Girl".localize
            }else{
                cell.lbGender.text = "Boy".localize
            }
            
            let url = URL(string: user!.image!)
            if url == nil {
                cell.avatar.image = UIImage(named: "avatar")
            }else{
                DispatchQueue.main.async {
                    cell.avatar?.kf.setImage(with: url)
                }
            }
            cell.imageProfile.kf.setImage(with: url)
            cell.lbName.text = user?.name
            cell.lbPhone.text = user?.phone
            cell.lbAddress.text = user?.nameAddress
            cell.lbAge.text = "\(user?.age ?? 0)"
            return cell
        }else if indexPath.section == 1{
            let cell: WorkInfoCell = tbInformation.dequeueReusableCell(withIdentifier: workInfoCellID, for: indexPath) as! WorkInfoCell
            
            cell.data = workTypeList
            cell.priceLabel.text = String().numberFormat(number: UserDefaultHelper.currentUser?.workInfor?.price ?? 0) + " VND" + " / " +  "hour".localize
            cell.topLabel.text = "WorkCapacity".localize.uppercased()
            cell.llbAssessment.text = "Assessment".localize.uppercased()
            
            return cell
        }else{
            let cell:InfoCommentCell = (tbInformation.dequeueReusableCell(withIdentifier: infoCommentCellID, for: indexPath) as? InfoCommentCell)!
            let comment = list[indexPath.row]
            let url = URL(string: (comment.fromId?.image)!)
            if  url == nil {
                cell.imageAvatar.image = UIImage(named: "avatar")
            }else{
                DispatchQueue.main.async {
                    cell.imageAvatar.kf.setImage(with: url)
                }
            }
            cell.userName.text = comment.fromId?.name
            let creatAt = String.convertISODateToString(isoDateStr: comment.createAt!, format: "dd/MM/yyyy")
            cell.createAtLabel.text = creatAt
            cell.content.allowsEditingTextAttributes = true
            cell.content.text = comment.content
            cell.workTitle.text = comment.task?.title
            return cell
        }
    }
}
extension InformationViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


