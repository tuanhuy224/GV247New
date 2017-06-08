//
//  OwnerHistoryViewController.swift
//  GV24
//
//  Created by admin on 6/5/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class OwnerHistoryViewController: BaseViewController {
    @IBOutlet weak var historyTableView: UITableView!
    
    @IBOutlet weak var segment: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.automaticallyAdjustsScrollViewInsets = false
        historyTableView.register(UINib(nibName:"OwnerHistoryViewCell",bundle:nil), forCellReuseIdentifier: "OwnerHistoryCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Chủ nhà đã làm"
        segment.selectedSegmentIndex = 1
    }
    
    override func setupViewBase() {
        super.setupViewBase()
    }
    
    @IBAction func valueChanged(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }

}

extension OwnerHistoryViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OwnerHistoryCell", for: indexPath) as! OwnerHistoryViewCell
        
        return cell
    }
}
extension OwnerHistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.colorWithRedValue(redValue: 237, greenValue: 236, blueValue: 243, alpha: 1)
        return footerView
    }
}
