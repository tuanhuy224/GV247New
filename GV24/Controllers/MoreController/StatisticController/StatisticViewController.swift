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
    var popUp = PopupViewController()
    var task = [Statistic]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tbStatistic.register(UINib(nibName:"OwnerHistoryViewCell",bundle:nil), forCellReuseIdentifier: "OwnerHistoryCell")
        getStatistic()
        loadData()
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
        title = "Thống kê"
    }
    override func decorate() {
        super.decorate()
        lbTotalPrice.text = "Tong thu nhap"
        lbPriceChange.text = "VND"
    }

    @IBAction func btChooseAction(_ sender: Any) {
       
        //showPopup(isFromDate: <#T##Bool#>, isToDate: <#T##Bool#>, fromDate: <#T##Date?#>, toDate: <#T##Date#>)
    }
    fileprivate func getStatistic(){
        let headers:HTTPHeaders = ["hbbgvauth":"\(UserDefaultHelper.getToken()!)"]
        let apiClient = APIService.shared
        apiClient.getOwner(url: APIPaths().urlStatistic(), param: [:], header: headers) { (json, error) in
            self.task = [Statistic(json: json!)]
            
        }
    }
    
    fileprivate func showPopup(isFromDate: Bool, isToDate: Bool, fromDate: Date?, toDate: Date) {
        popUp.modalPresentationStyle = .overCurrentContext
        popUp.delegate = self
        popUp.isFromDate = isFromDate
        popUp.isToDate = isToDate
        popUp.fromDate = fromDate
        popUp.toDate = toDate
        present(popUp, animated: true) {
            self.popUp.effectView.alpha = 0.5
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension StatisticViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return task.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbStatistic.dequeueReusableCell(withIdentifier: "OwnerHistoryCell", for: indexPath)
        return cell
    }
}
extension StatisticViewController:PopupViewControllerDelegate{
    func selectedDate(date: Date, isFromDate: Bool, isToDate: Bool) {
        
    }

}

