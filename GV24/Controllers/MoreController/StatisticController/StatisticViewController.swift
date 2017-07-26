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
    var statistic: Statistic? {
        didSet {
            if let statistic = statistic {
                self.lbTotalPriceNumber.text = "\(self.numberFormatter.string(from: NSNumber(value: statistic.totalPrice)) ?? "0")"
            }
        }
    }
    var startAtDate = Date(timeIntervalSince1970: 0) {
        didSet {
            btChooseDay.setTitle(self.dateFormatter.string(from: startAtDate), for: .normal)
        }
    }
    var endAtDate = Date() {
        didSet {
            btChooseDayTwo.setTitle(self.dateFormatter.string(from: endAtDate), for: .normal)
        }
    }
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.currencyGroupingSeparator = "."
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    @IBOutlet weak var lbDuration: UILabel!
    @IBOutlet weak var lbCompletedWork: UILabel!
    @IBOutlet weak var lbInProcess: UILabel!
    @IBOutlet weak var lbPendingConfirmation: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbStatistic.register(UINib(nibName: NibStatisticCell,bundle:nil), forCellReuseIdentifier: statisticCellID)
        
        endAtDate = Date()
        tbStatistic.allowsSelection = false
        getStatistic(startAt: startAtDate, endAt: endAtDate)
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
    
    func showLoading() {
        indicator.startAnimating()
        lbTotalPriceNumber.isHidden = true
    }
    
    func hideLoading() {
        indicator.stopAnimating()
        lbTotalPriceNumber.isHidden = false
    }
    
    func updateUI() {
        
        guard let statistic = statistic else {
            return
        }
        
        // update task number
        let tasks = statistic.tasks
        for task in tasks {
            switch task.id {
            case .completed:
                self.lbTotalDone.text = String(task.count)
            case .awaiting:
                self.lbTotalWaiting.text = String(task.count)
            case .inProcess:
                self.lbTotalProcessing.text = String(task.count)
            default:
                // do nothing
                break
            }
        }
        
    }

    /* get Statistic /maid/statistical
     params:
     +startAt (opt): ISODate
     +endAt (opt): ISODate"
     */
    fileprivate func getStatistic(startAt: Date?, endAt: Date) {
        
        showLoading()
        
        var params: [String:Any] = [:]
        if startAt != nil {
            params["startAt"] = "\(String.convertDateToISODateType(date: startAt!)!)"
        }
        params["endAt"] = "\(String.convertDateToISODateType(date: endAt)!)"
 
        let headers:HTTPHeaders = ["hbbgvauth":"\(UserDefaultHelper.getToken()!)"]
        let apiClient = APIService.shared
        apiClient.getOwner(url: APIPaths().urlStatistic(), param: params, header: headers) { (json, error) in
            
            if let json = json {
                self.statistic = Statistic(json: json)
                self.updateUI()
            } else {
                AlertStandard.sharedInstance.showAlert(controller: self, title: "Notifications".localize, message: "NoDataFound".localize)
            }
            
            self.hideLoading()
            
        }
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
        popup.show()
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
        cell.userNameLabel.text = user.name
        cell.addressLabel.text = user.nameAddress
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension StatisticViewController:PopupViewControllerDelegate{
    func selectedDate(date: Date, isFromDate: Bool, isToDate: Bool) {
        if isFromDate == true {
            startAtDate = date
        } else {
            endAtDate = date
        }
        self.getStatistic(startAt: startAtDate, endAt: endAtDate)
    }

}

