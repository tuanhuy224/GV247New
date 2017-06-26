//
//  ManagerHistoryViewController.swift
//  GV24
//
//  Created by admin on 6/9/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class ManagerHistoryViewController: BaseViewController {

    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var toDateButton: UIButton!
    @IBOutlet weak var fromDateButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    var workListVC: HistoryViewController?
    var ownerListVC: OwnerHistoryViewController?
    var fromDate: Date? = nil
    var toDate: Date = Date()
    var currentSelectedIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customNavigationController()
        setupContainerView()
        setupConstrains()
        setupSegmentTitle()
        addSwipeGesture()
    }
    
    func addSwipeGesture() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(doSwipeTab(gesture:)))
        swipeLeft.direction = .left
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(doSwipeTab(gesture:)))
        swipeRight.direction = .right
        self.containerView.addGestureRecognizer(swipeLeft)
        self.containerView.addGestureRecognizer(swipeRight)
    }
    
    func doSwipeTab(gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case UISwipeGestureRecognizerDirection.right:
            self.segmentControl.selectedSegmentIndex = 0
            break
        default:
            self.segmentControl.selectedSegmentIndex = 1
            break
        }
        if currentSelectedIndex != self.segmentControl.selectedSegmentIndex {
            self.doValueChanged(self.segmentControl)
        }
    }
    
    func setupSegmentTitle() {
        self.segmentControl.setTitle("CompletedWork".localize, forSegmentAt: 0)
        self.segmentControl.setTitle("Workplace".localize, forSegmentAt: 1)
        self.toLabel.text = "Duration".localize
    }
    
    func customNavigationController() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    func setupContainerView() {
        workListVC = HistoryViewController()
        ownerListVC = OwnerHistoryViewController()
        
        workListVC?.view.frame = containerView.frame
        ownerListVC?.view.frame = containerView.frame
        
        containerView.addSubview((workListVC?.view)!)
        containerView.addSubview((ownerListVC?.view)!)
        
        workListVC?.view.tag = 0
        ownerListVC?.view.tag = 1
    }
    
    func setupConstrains() {
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
        title = "WorkHistory".localize//"Lịch sử công việc"
    }
    
    @IBAction func doValueChanged(_ sender: UISegmentedControl) {
        print("selected : \(sender.selectedSegmentIndex)")
        if sender.selectedSegmentIndex == 1 {
            workListVC?.view.isHidden = true
            ownerListVC?.view.isHidden = false
            currentSelectedIndex = 1
            self.reloadOwnerListViewController()
        }
        else {
            workListVC?.view.isHidden = false
            ownerListVC?.view.isHidden = true
            currentSelectedIndex = 0
            self.reloadWorkListViewController()
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
    
    func reloadWorkListViewController() {
        workListVC?.workList.removeAll()
        workListVC?.historyTableView.reloadData()
        workListVC?.startAtDate = fromDate
        workListVC?.endAtDate = toDate
        workListVC?.page = 1
        workListVC?.getWorkList(startAt: fromDate, endAt: toDate)
    }
    
    func reloadOwnerListViewController() {
        ownerListVC?.ownerList.removeAll()
        ownerListVC?.tableView.reloadData()
        ownerListVC?.startAtDate = fromDate
        ownerListVC?.endAtDate = toDate
        ownerListVC?.getOwnerList(startAt: fromDate, endAt: toDate)
    }
    
    override func setupViewBase() {}
    
    override func decorate() {}
}

extension ManagerHistoryViewController: PopupViewControllerDelegate {
    func selectedDate(date: Date, isFromDate: Bool, isToDate: Bool) {
        if isFromDate == true {
            fromDateButton.setTitle(String.convertDateToString(date: date, withFormat: "dd/MM/yyyy"), for: UIControlState.normal)
            fromDate = date
        }
        else {
            toDateButton.setTitle(String.convertDateToString(date: date, withFormat: "dd/MM/yyyy"), for: UIControlState.normal)
            toDate = date
        }
        if segmentControl.selectedSegmentIndex == 0 {
            self.reloadWorkListViewController()
        }
        else {
            self.reloadOwnerListViewController()
        }
    }
}
