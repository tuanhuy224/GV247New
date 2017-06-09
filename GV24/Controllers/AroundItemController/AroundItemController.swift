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
    override func viewDidLoad() {
        super.viewDidLoad()
        tbAround.register(UINib(nibName:"HistoryViewCell",bundle:nil), forCellReuseIdentifier: "historyCell")
        loadAroundItem()
        tbAround.reloadData()
    }
    func loadAroundItem(){
        let url = "https://yukotest123.herokuapp.com/en/more/getTaskByWork"
        let parameter:[String:Any] = ["work":id!,"lng": 106.6882557,"lat": 10.7677238,"maxDistance":300]
        let apiClient = AroundTask.sharedInstall
        apiClient.getWorkFromURL(url: url, parameter: parameter) { (works, string) in
            if string == nil{
                self.works = works!
                self.tbAround.reloadData()
            }
        }
    }
    override func setupViewBase() {
        self.title = name?.localize
        tbAround.reloadData()
    }
}
extension AroundItemController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return works.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:HistoryViewCell = tbAround.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryViewCell
        cell.workNameLabel.text = works[indexPath.row].info?.title
        cell.lbDist.text = "\(Int(works[indexPath.row].dist!.calculated!)) m"
        cell.createdDate.text = Date(isoDateString: (works[indexPath.row].history!.createAt!)).dayMonthYear
        cell.lbTimePost.text = Date(isoDateString: (works[indexPath.row].history!.createAt!)).hourMinuteSecond
        cell.timeWork.text = "\(Date(isoDateString: (works[indexPath.row].workTime?.startAt)!).hourMinute)\(" - ")\(Date(isoDateString: (works[indexPath.row].workTime?.endAt)!).hourMinute)"
        DispatchQueue.main.async {
            cell.imageWork.kf.setImage(with: URL(string: self.works[indexPath.row].info!.workName!.image!))
        }
        return cell
    }
}
extension AroundItemController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = DetailViewController(nibName: "DetailViewController", bundle: nil)
        detail.works = works[indexPath.row]
        detail.idWork = works[indexPath.row].id
        detail.titleString = works[indexPath.row].info?.title
        navigationController?.pushViewController(detail, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
}

extension AroundItemController:sendIdForViewDetailDelegate{
    func sendId(id: String) {
        self.id = id
    }
}
