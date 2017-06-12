//
//  ManageViewController.swift
//  GV24
//
//  Created by HuyNguyen on 6/1/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class ManageViewController: BaseViewController {
    @IBOutlet weak var segmentCtr: UISegmentedControl!
    @IBOutlet weak var tbManage: UITableView!
    var idProcess:String?
    var returnValue:Int = 0
    var case1Sting = ["1","2","3"]
    var case2String = ["a","b","c","s","d"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tbManage.register(UINib(nibName:"HistoryViewCell",bundle:nil), forCellReuseIdentifier: "historyCell")
    }
    @IBAction func segmentControlAction(_ sender: Any) {
        tbManage.reloadData()
    }
}

func getProcess() {
//    let url = ""
//    let parameter = ["process":"\()"]
//    let header = ["hbbgvauth":"\(UserDefaultHelper.getToken()!)"]
//    let apiService = APIService.shared
//    apiService.getUrl(url: <#T##String#>, param: <#T##Parameters#>, header: <#T##HTTPHeaders#>, completion: <#T##(ResponseCompletion)##(ResponseCompletion)##(JSON?, String?) -> ()#>)
}

extension ManageViewController:UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentCtr.selectedSegmentIndex {
        case 0:
            returnValue = case1Sting.count
            break
        case 1:
            returnValue = case2String.count
            break
        default:
            break
        }
        return returnValue
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbManage.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as? HistoryViewCell
        switch segmentCtr.selectedSegmentIndex {
        case 0:
            cell?.workNameLabel.text = case1Sting[indexPath.row]
        case 1:
            cell?.workNameLabel.text = case2String[indexPath.row]
        default:
            break
        }
        return cell!
    }
}
extension ManageViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

