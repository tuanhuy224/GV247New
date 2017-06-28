//
//  StatisticViewController.swift
//  GV24
//
//  Created by HuyNguyen on 6/22/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Alamofire

class StatisticViewController: BaseViewController {
    @IBOutlet weak var lbTotalPriceNumber: UILabel!
    @IBOutlet weak var tbStatistic: UITableView!
    @IBOutlet weak var btChooseDay: UIButton!
    @IBOutlet weak var btChooseDayTwo: UIButton!
    @IBOutlet weak var lbTotalPrice: UILabel!
    @IBOutlet weak var lbPriceChange: UILabel!
    @IBOutlet weak var lbTotalWaiting: UILabel!
    @IBOutlet weak var lbTotalProcessing: UILabel!
    @IBOutlet weak var lbTotalDone: UILabel!
    var popUp = PopupViewController()
    var task = [Statistic]()
    var startAtDate: Date? = nil
    var endAtDate: Date = Date()
    
    @IBOutlet weak var lbDuration: UILabel!
    @IBOutlet weak var lbCompletedWork: UILabel!
    @IBOutlet weak var lbInProcess: UILabel!
    @IBOutlet weak var lbPendingConfirmation: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        tbStatistic.register(UINib(nibName: NibStatisticCell,bundle:nil), forCellReuseIdentifier: statisticCellID)
        getStatistic(startAt: startAtDate, endAt: endAtDate)
    }
    func loadData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            for data in self.task{
            self.lbTotalPriceNumber.text = "\(String(describing: data.totalPrice!))"
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Statistic".localize
    }
    override func decorate() {
        super.decorate()
        lbTotalPrice.text = "TotalEarnings".localize
        lbPriceChange.text = "VND"
        
        lbDuration.text = "Duration".localize
        lbInProcess.text = "InProcess".localize
        lbPendingConfirmation.text = "PendingConfirmation".localize
        lbCompletedWork.text = "CompletedWork".localize
    }

    /* get Statistic /maid/statistical
     params:
     +startAt (opt): ISODate
     +endAt (opt): ISODate"
     */
    fileprivate func getStatistic(startAt: Date?, endAt: Date){
        var params: [String:Any] = [:]
        if startAt != nil {
            params["startAt"] = "\(String.convertDateToISODateType(date: startAt!)!)"
        }
        params["endAt"] = "\(String.convertDateToISODateType(date: endAt)!)"
 
        let headers:HTTPHeaders = ["hbbgvauth":"\(UserDefaultHelper.getToken()!)"]
        let apiClient = APIService.shared
        apiClient.getOwner(url: APIPaths().urlStatistic(), param: [:], header: headers) { (json, error) in
            if (self.net?.isReachable)! {
                if json != nil {
                    DispatchQueue.main.async {
                        self.task = [Statistic(json: json!)]
                        self.loadData()
                    }
                }else {
                    DispatchQueue.main.async {
                        let alertController = AlertHelper().showAlertError(title: "Announcement".localize, message: "NoDataFound".localize)
                        self.present(alertController, animated: true, completion: nil)
                    }
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
    @IBAction func btChooseDayClicked(_ sender: Any) {
        showPopup(isFromDate: true, isToDate: false, fromDate: startAtDate, toDate: endAtDate)
    }
    
    @IBAction func btChooseDayTwoClicked(_ sender: Any) {
        showPopup(isFromDate: false, isToDate: true, fromDate: startAtDate, toDate: endAtDate)
    }
    
    fileprivate func showPopup(isFromDate: Bool, isToDate: Bool, fromDate: Date?, toDate: Date) {
        let popup = PopupViewController()
        popup.modalPresentationStyle = .overCurrentContext
        popup.delegate = self
        popup.isFromDate = isFromDate
        popup.isToDate = isToDate
        popup.fromDate = fromDate
        popup.toDate = toDate
        present(popup, animated: true) {
            popup.effectView.alpha = 0.5
        }
    }
}
extension StatisticViewController:UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbStatistic.dequeueReusableCell(withIdentifier: statisticCellID, for: indexPath) as! StatisticCell
        let user = UserDefaultHelper.currentUser!
        if let imageString = user.image {
            let url = URL(string: imageString)
            cell.userImage.kf.setImage(with: url, placeholder: UIImage(named: "nau an"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        cell.userNameLabel.text = user.username
        cell.addressLabel.text = user.nameAddress
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //let vc = InformationViewController()
        //_ = navigationController?.pushViewController(vc, animated: true)
    }
}
extension StatisticViewController:PopupViewControllerDelegate{
    func selectedDate(date: Date, isFromDate: Bool, isToDate: Bool) {
        if isFromDate == true {
            btChooseDay.setTitle(String.convertDateToString(date: date, withFormat: "dd/MM/yyyy"), for: UIControlState.normal)
            startAtDate = date
        }
        else {
            btChooseDayTwo.setTitle(String.convertDateToString(date: date, withFormat: "dd/MM/yyyy"), for: UIControlState.normal)
            endAtDate = date
        }
        self.getStatistic(startAt: startAtDate, endAt: endAtDate)
    }

}

