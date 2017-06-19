//
//  InformationViewController.swift
//  GV24
//
//  Created by HuyNguyen on 5/31/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Kingfisher

class InformationViewController: BaseViewController {

    @IBOutlet weak var tbInformation: UITableView!
    var user:User?
    override func viewDidLoad() {
        super.viewDidLoad()
        tbInformation.register(UINib(nibName:NibInforCell,bundle:nil), forCellReuseIdentifier: inforCellID)
        tbInformation.register(UINib(nibName:NibCommentCell,bundle:nil), forCellReuseIdentifier: commentCellID)
        tbInformation.allowsSelection = false
        self.user = UserDefaultHelper.currentUser
        customBarLeftButton()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(InformationViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
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
        button.setTitle("Cập nhật", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
        button.frame = CGRect(x: 0, y: 0, width: 70, height: 30)
        button.setTitleColor(UIColor(red: 46/255, green: 186/255, blue: 191/255, alpha: 1), for: .normal)
        button.setTitleColor(UIColor.brown, for: .highlighted)
        button.addTarget(self, action: #selector(InformationViewController.selectButton), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    func selectButton() {
        navigationController?.pushViewController(DetailViewController(), animated: true)
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
}
extension InformationViewController:UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
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
        }else{
            let cell:CommentCell = tbInformation.dequeueReusableCell(withIdentifier: commentCellID, for: indexPath) as! CommentCell
            let url = URL(string: (user?.image)!)
            let data = try? Data(contentsOf: url!)
            if let imageData = data {
                let image = UIImage(data: imageData)
                DispatchQueue.main.async {
                    cell.imageAvatar?.image = image
                }
            }
            return cell
        }
    }
}
extension InformationViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 265
        }
        return 200
    }
}





