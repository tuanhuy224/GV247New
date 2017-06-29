//
//  AroundItemController.swift
//  GV24
//
//  Created by HuyNguyen on 6/7/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Kingfisher

class AroundItemController: BaseViewController {
    @IBOutlet weak var tbAround: UITableView!
    var id:String?
    var name:String?
    var works = [Work]()
    var currentLocation: CLLocationCoordinate2D?
    override func viewDidLoad() {
        super.viewDidLoad()
        tbAround.register(UINib(nibName:NibHistoryViewCell,bundle:nil), forCellReuseIdentifier: HistoryViewCellID)
        loadAroundItem()
        tbAround.separatorStyle = .none
        tbAround.reloadData()
        self.tbAround.rowHeight = UITableViewAutomaticDimension
        self.tbAround.estimatedRowHeight = 100.0
    }
    func loadAroundItem(){
        let parameter:[String:Any] = ["work":id!,"lng": currentLocation!.longitude,"lat": currentLocation!.latitude,"maxDistance":5]
        let apiClient = AroundTask.sharedInstall
        MBProgressHUD.showAdded(to: self.view, animated: true)
        apiClient.getWorkFromURL(url: APIPaths().getTaskByAround(), parameter: parameter) { (works, string) in
            if string == nil{
                self.works = works!
                MBProgressHUD.hide(for: self.view, animated: true)
                self.tbAround.reloadData()
            }
        }
    }
    override func setupViewBase() {
        self.title = "\(name!)".localize
        tbAround.reloadData()
    }
}
extension AroundItemController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return works.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:HistoryViewCell = tbAround.dequeueReusableCell(withIdentifier: HistoryViewCellID, for: indexPath) as! HistoryViewCell
        cell.workNameLabel.text = works[indexPath.row].info?.title
        cell.lbDist.text = "\(Int(works[indexPath.row].dist!.calculated!)) m"
        cell.createdDate.text = Date(isoDateString: (works[indexPath.row].history!.createAt!)).dayMonthYear
        cell.lbTimePost.text = Date().dateComPonent(datePost: (works[indexPath.row].history!.createAt!))
        DispatchQueue.main.async {
            cell.imageWork.kf.setImage(with: URL(string: self.works[indexPath.row].info!.workName!.image!))
        }
         cell.timeWork.text = String.convertISODateToString(isoDateStr: (works[indexPath.row].workTime?.startAt)!, format: "HH:mm a")! + " - " + String.convertISODateToString(isoDateStr: (works[indexPath.row].workTime?.endAt)!, format: "HH:mm a")!
        cell.lbDeadline.isHidden = true
        return cell
    }
}
extension AroundItemController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = DetailViewController(nibName: NibDetailViewController, bundle: nil)
        detail.works = works[indexPath.row]
        detail.idWork = works[indexPath.row].id
        detail.titleString = works[indexPath.row].info?.title
        if UserDefaultHelper.getToken() == nil {
            AlertStandard.sharedInstance.showAlertCt(controller: self, pushVC: LoginView(), title: "", message: "Pleasesign".localize)
        }
        navigationController?.pushViewController(detail, animated: true)
    }
}

extension AroundItemController:sendIdForViewDetailDelegate{
    func sendId(id: String) {
        self.id = id
    }
}
