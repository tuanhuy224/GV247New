//
//  ManagerHistoryViewController.swift
//  GV24
//
//  Created by admin on 6/9/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class ManagerHistoryViewController: UIViewController {

    @IBOutlet weak var toDateButton: UIButton!
    @IBOutlet weak var fromDateButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    var workListVC: HistoryViewController?
    var ownerListVC: OwnerHistoryViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        workListVC = HistoryViewController()
        ownerListVC = OwnerHistoryViewController()
        
        workListVC?.view.frame = containerView.frame
        ownerListVC?.view.frame = containerView.frame
        
        containerView.addSubview((workListVC?.view)!)
        containerView.addSubview((ownerListVC?.view)!)
        
        workListVC?.view.translatesAutoresizingMaskIntoConstraints = false
        workListVC?.view.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 0).isActive = true
        workListVC?.view.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 0).isActive = true
        workListVC?.view.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: 0).isActive = true
        workListVC?.view.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: 0).isActive = true
        
        ownerListVC?.view.translatesAutoresizingMaskIntoConstraints = false
        ownerListVC?.view.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 0).isActive = true
        ownerListVC?.view.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 0).isActive = true
        ownerListVC?.view.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: 0).isActive = true
        ownerListVC?.view.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: 0).isActive = true
        
        ownerListVC?.view.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Lịch sử công việc"
    }
    
    @IBAction func doValueChanged(_ sender: UISegmentedControl) {
        print("selected : \(sender.selectedSegmentIndex)")
        if sender.selectedSegmentIndex == 1 {
            workListVC?.view.isHidden = true
            ownerListVC?.view.isHidden = false
        }
        else {
            workListVC?.view.isHidden = false
            ownerListVC?.view.isHidden = true
        }
    }

    @IBAction func fromDateButtonClicked(_ sender: Any) {
        
    }

    @IBAction func toDateButtonClicked(_ sender: Any) {
        
    }
    
}
