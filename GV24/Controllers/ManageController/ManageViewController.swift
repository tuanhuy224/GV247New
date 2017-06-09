//
//  ManageViewController.swift
//  GV24
//
//  Created by HuyNguyen on 6/1/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class ManageViewController: BaseViewController {
    @IBOutlet weak var tbManage: UITableView!
    var idProcess:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        tbManage.register(UINib(nibName:"HistoryViewCell",bundle:nil), forCellReuseIdentifier: "historyCell")
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
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbManage.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as? HistoryViewCell
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

