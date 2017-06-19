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

class InformationViewController: BaseViewController {

    @IBOutlet weak var tbInformation: UITableView!
    var user:User?
    override func viewDidLoad() {
        super.viewDidLoad()
        tbInformation.register(UINib(nibName:NibInforCell,bundle:nil), forCellReuseIdentifier: inforCellID)
        tbInformation.register(UINib(nibName:NibCommentCell,bundle:nil), forCellReuseIdentifier: commentCellID)
        tbInformation.register(UINib(nibName: NibWorkInfoCell, bundle: nil), forCellReuseIdentifier: workInfoCellID)
        tbInformation.allowsSelection = false
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
    /*
        /maid/getComment 
     params: - id: userId
    */
    func getOwnerComments() {
        print("UserID = \(self.user?.id)")
    }
}
extension InformationViewController:UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
            cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            return cell
        }else{
            let cell:CommentCell = tbInformation.dequeueReusableCell(withIdentifier: commentCellID, for: indexPath) as! CommentCell
            let url = URL(string: (user?.image)!)
            DispatchQueue.main.async {
                cell.imageAvatar.kf.setImage(with: url)
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

extension InformationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "workInfoCollectionViewCell", for: indexPath) as! WorkInfoCollectionViewCell
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("collection view selected: \(indexPath.row)")
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? WorkInfoCell else { return }
        
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
    }
}





