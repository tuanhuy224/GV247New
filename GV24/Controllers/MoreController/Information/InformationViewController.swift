//
//  InformationViewController.swift
//  GV24
//
//  Created by HuyNguyen on 5/31/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Kingfisher
import IoniconsSwift
import Alamofire

class InformationViewController: BaseViewController {

    @IBOutlet weak var tbInformation: UITableView!
    var user:User?
    var page: Int = 1
    var limit: Int = 10
    var list: [Comment] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tbInformation.register(UINib(nibName:NibInforCell,bundle:nil), forCellReuseIdentifier: inforCellID)
        tbInformation.register(UINib(nibName:NibInfoCommentCell,bundle:nil), forCellReuseIdentifier: infoCommentCellID)
        tbInformation.register(UINib(nibName: NibWorkInfoCell, bundle: nil), forCellReuseIdentifier: workInfoCellID)
        self.user = UserDefaultHelper.currentUser
        customBarLeftButton()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(InformationViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        getOwnerComments()
    }
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        view.endEditing(true)
    }
    override func setupViewBase() {
        self.title = "Information".localize
    }
    func customBarLeftButton(){
        let button = UIButton(type: .custom)
        button.setTitle("Update".localize, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
        button.frame = CGRect(x: 0, y: 0, width: 70, height: 30)
        button.setTitleColor(UIColor(red: 46/255, green: 186/255, blue: 191/255, alpha: 1), for: .normal)
        button.setTitleColor(UIColor.brown, for: .highlighted)
        button.addTarget(self, action: #selector(InformationViewController.selectButton), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
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
        var params:[String:Any] = [:]
        params["id"] = "\((self.user?.id)!)"
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
            if user?.gender == 0 {
                cell.lbGender.text = gender.girl
            }else{
                cell.lbGender.text = gender.boy
            }
            let url = URL(string: user!.image!)
            DispatchQueue.main.async {
                cell.avatar?.kf.setImage(with: url)
            }
            cell.imageProfile.kf.setImage(with: url)
            cell.lbName.text = user?.username
            cell.lbPhone.text = user?.phone
            cell.lbAddress.text = user?.nameAddress
            return cell
        }else if indexPath.section == 1{
            let cell: WorkInfoCell = tbInformation.dequeueReusableCell(withIdentifier: workInfoCellID, for: indexPath) as! WorkInfoCell
//            cell.priceLabel.text = 
            cell.data = ["Trông trẻ","Nấu ăn","Thú cưng","a","b","c","a","b","c","a","b","c"]
            return cell
        }else{
            let cell:InfoCommentCell = tbInformation.dequeueReusableCell(withIdentifier: infoCommentCellID, for: indexPath) as! InfoCommentCell
            let comment = list[indexPath.row]
            let url = URL(string: (comment.fromId?.image)!)
            DispatchQueue.main.async {
                cell.imageAvatar.kf.setImage(with: url)
            }
            cell.userName.text = comment.fromId?.name
            let creatAt = String.convertISODateToString(isoDateStr: comment.createAt!, format: "dd/MM/yyyy")
            cell.createAtLabel.text = creatAt
            cell.content.text = comment.content
            cell.workTitle.text = comment.task?.title
            if indexPath.row != 0 {
                cell.topLabelHeight.constant = 0
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tableview selected: \(indexPath.row)")
    }
}
extension InformationViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 320
        }
        else if indexPath.section == 1 {
            return 154
        }
        return 170
    }
}




