//
//  ManagerHistoryViewController.swift
//  GV24
//
//  Created by admin on 6/9/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class ManagerHistoryViewController: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var toDateButton: UIButton!
    @IBOutlet weak var fromDateButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    var workListVC: HistoryViewController?
    var ownerListVC: OwnerHistoryViewController?
    var fromDate: Date? = nil
    var toDate: Date = Date()
    
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
        workListVC?.myParent = self
        ownerListVC?.myParent = self
        
        toDateButton.setTitle(String.convertDateToString(date: toDate, withFormat: "dd/MM/yyyy"), for: UIControlState.normal)
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
       showPopup(isFromDate: true, isToDate: false, fromDate: fromDate, toDate: toDate)
    }

    @IBAction func toDateButtonClicked(_ sender: Any) {
        showPopup(isFromDate: false, isToDate: true, fromDate: fromDate, toDate: toDate)
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

extension ManagerHistoryViewController: PopupViewControllerDelegate {
    func selectedDate(date: Date, isFromDate: Bool, isToDate: Bool) {
        print("Date: \(date)")
        if isFromDate == true {
            fromDateButton.setTitle(String.convertDateToString(date: date, withFormat: "dd/MM/yyyy"), for: UIControlState.normal)
            fromDate = date
        }
        else {
            toDateButton.setTitle(String.convertDateToString(date: date, withFormat: "dd/MM/yyyy"), for: UIControlState.normal)
            toDate = date
        }
        if segmentControl.selectedSegmentIndex == 0 {
            workListVC?.workList.removeAll()
            workListVC?.getWorkList(startAt: fromDate, endAt: toDate)
        }
        else {
            ownerListVC?.ownerList.removeAll()
            ownerListVC?.getOwnerList(startAt: fromDate, endAt: toDate)
        }
    }
}
