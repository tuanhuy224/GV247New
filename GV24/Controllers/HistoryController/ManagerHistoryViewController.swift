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
    
    var firstFromDate: Date? = nil
    var firstToDate: Date = Date()
    var secondFromDate : Date? = nil
    var secondToDate : Date = Date()
    
    var currentSelectedIndex: Int = 0
    var isFirstTime: Bool = true
    var isDisplayAlert:Bool = false
    var billId:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customNavigationController()
        setupContainerView()
        setupConstrains()
        setupSegmentTitle()
        addSwipeGesture()
        segmentControl.tintColor = AppColor.backButton
        fromDateButton.tintColor = AppColor.backButton
        toDateButton.tintColor = AppColor.backButton
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
        if isFirstTime == true {
            setupOwnerHistory()
            isFirstTime = false
        }
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
        self.segmentControl.setTitle("CompleteW".localize, forSegmentAt: 0)
        self.segmentControl.setTitle("Formerpartners".localize, forSegmentAt: 1)
        self.toLabel.text = "Duration".localize
    }
    
    func customNavigationController() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    func setupContainerView() {
        workListVC = HistoryViewController()
        workListVC?.view.frame = containerView.frame
        containerView.addSubview((workListVC?.view)!)
        workListVC?.view.tag = 0
    }
    func setupOwnerHistory() {
        ownerListVC = OwnerHistoryViewController()
        ownerListVC?.view.frame = containerView.frame
        containerView.addSubview((ownerListVC?.view)!)
        ownerListVC?.view.tag = 1
        setupConstraint(vc: ownerListVC!)
        ownerListVC?.view.isHidden = true
        
        ownerListVC?.myParent = self
    }
    func setupConstraint(vc: BaseViewController) {
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 0).isActive = true
        vc.view.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 0).isActive = true
        vc.view.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: 0).isActive = true
        vc.view.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: 0).isActive = true
    }
    
    func setupConstrains() {
        setupConstraint(vc: workListVC!)
        workListVC?.myParent = self
        toDateButton.setTitle(String.convertDateToString(date: Date(), withFormat: "dd/MM/yyyy"), for: .normal)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "WorkHistory".localize//"Lịch sử công việc"
    }
    
    @IBAction func doValueChanged(_ sender: UISegmentedControl) {
        print("selected : \(sender.selectedSegmentIndex)")
        self.currentSelectedIndex = self.segmentControl.selectedSegmentIndex
        
        if isFirstTime {
            setupOwnerHistory()
            isFirstTime = false
            
        }
        
        if sender.selectedSegmentIndex == 1 {
            workListVC?.view.isHidden = true
            ownerListVC?.view.isHidden = false
            
            if let date = secondFromDate {
                fromDateButton.setTitle(String.convertDateToString(date: date, withFormat: "dd/MM/yyyy"), for: .normal)
            }
            toDateButton.setTitle(String.convertDateToString(date: secondToDate, withFormat: "dd/MM/yyyy"), for: .normal)
            
            self.reloadOwnerListViewController()
        }else {
            workListVC?.view.isHidden = false
            ownerListVC?.view.isHidden = true
            
            if let date = firstFromDate {
                fromDateButton.setTitle(String.convertDateToString(date: date, withFormat: "dd/MM/yyyy"), for: .normal)
            }
            toDateButton.setTitle(String.convertDateToString(date: firstToDate, withFormat: "dd/MM/yyyy"), for: .normal)
            
            self.reloadWorkListViewController()
        }
    }
    
    @IBAction func fromDateButtonClicked(_ sender: Any) {
        self.segmentControl.selectedSegmentIndex == 0 ? showPopup(isFromDate: true, fromDate: firstFromDate, toDate: firstToDate) : showPopup(isFromDate: true, fromDate: secondFromDate, toDate: secondToDate)
    }
    
    @IBAction func toDateButtonClicked(_ sender: UIButton) {
        self.segmentControl.selectedSegmentIndex == 0 ? showPopup(isFromDate: false, fromDate: firstFromDate, toDate: firstToDate) : showPopup(isFromDate: false, fromDate: secondFromDate, toDate: secondToDate)
    }
    
    fileprivate func showPopup(isFromDate: Bool, fromDate: Date?, toDate: Date?) {
        let popup = PopupViewController()
        popup.delegate = self
        popup.isFromDate = isFromDate
        popup.fromDate = fromDate
        popup.toDate = toDate
        popup.show()
    }
    
    func reloadWorkListViewController() {
        workListVC?.workList.removeAll()
        workListVC?.historyTableView.reloadData()
        
        workListVC?.startAtDate = firstFromDate
        workListVC?.endAtDate = firstToDate
        workListVC?.page = 1
        workListVC?.getWorkList(startAt: firstFromDate, endAt: firstToDate)
    }
    
    func reloadOwnerListViewController() {
        ownerListVC?.ownerList.removeAll()
        ownerListVC?.tableView.reloadData()
        
        ownerListVC?.startAtDate = secondFromDate
        ownerListVC?.endAtDate = secondToDate
        ownerListVC?.getOwnerList(startAt: secondFromDate, endAt: secondToDate)
    }
    override func setupViewBase() {
        super.setupViewBase()
        guard let token = UserDefaultHelper.getToken() else {return}
        let alert = AlertStandard.sharedInstance
        let header = ["Content-Type":"application/x-www-form-urlencoded","hbbgvauth": token]
        guard let bill = billId else{return}
        let param = ["billId":bill]
        let apiClient = APIService.shared
        if isDisplayAlert == true {
            self.isDisplayAlert = false
            alert.showAlertCt(controller: self,pushVC: nil, title: "WorkCompleted".localize, message: "confirmReceive".localize, completion: {
                apiClient.postRequest(url: APIPaths().paymentPayDirectConfirm(), method: .post, parameters: param, header: header, completion: { (json, error) in
                    
                })
            })
        }
    }
}
extension ManagerHistoryViewController: PopupViewControllerDelegate {
    func selectedDate(date: Date, isFromDate: Bool) {
        if isFromDate {
            if segmentControl.selectedSegmentIndex == 0 {
                fromDateButton.setTitle(String.convertDateToString(date: date, withFormat: "dd/MM/yyyy"), for: .normal)
                firstFromDate = date
            } else {
                fromDateButton.setTitle(String.convertDateToString(date: date, withFormat: "dd/MM/yyyy"), for: .normal)
                secondFromDate = date
            }
        } else {
            if segmentControl.selectedSegmentIndex == 0 {
                toDateButton.setTitle(String.convertDateToString(date: date, withFormat: "dd/MM/yyyy"), for: .normal)
                firstToDate = date
            } else {
                toDateButton.setTitle(String.convertDateToString(date: date, withFormat: "dd/MM/yyyy"), for: .normal)
                secondToDate = date
            }
        }
        
        if segmentControl.selectedSegmentIndex == 0 {
            self.reloadWorkListViewController()
        }else {
            self.reloadOwnerListViewController()
        }
    }
}
