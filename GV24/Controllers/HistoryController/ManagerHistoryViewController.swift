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
    var currentDate:Date?
    var currentSelectedIndex: Int = 0
    var isFirstTime: Bool = true
    var isDisplayAlert:Bool = false
    var billId:String?
    var isChooseDate: Bool = false
    var fromDateChoose: Date?
    
    var toDateChoose: Date?
    
    
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
        
        toDateButton.setTitle(String.convertDateToString(date: toDate, withFormat: "dd/MM/yyyy"), for: UIControlState.normal)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "WorkHistory".localize//"Lịch sử công việc"
    }
    
    @IBAction func doValueChanged(_ sender: UISegmentedControl) {
        print("selected : \(sender.selectedSegmentIndex)")
        if isFirstTime == true {
            setupOwnerHistory()
            isFirstTime = false
        }
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

       showPopup(isFromDate: true, isToDate: false, fromDate: fromDate, toDate: toDate )
    }

    @IBAction func toDateButtonClicked(_ sender: Any) {
        showToDate(isFromDate: false, isToDate: true, fromDate: fromDate, toDate: toDate )
    }
    
    fileprivate func showPopup(isFromDate: Bool, isToDate: Bool, fromDate: Date?, toDate: Date?) {
        let popup = PopupViewController()
        popup.delegate = self
        popup.isFromDate = isFromDate
        popup.isToDate = isToDate
        popup.fromDate = fromDate
        popup.toDate = toDate
        popup.show()
    }
    
    fileprivate func showToDate(isFromDate: Bool, isToDate: Bool, fromDate: Date?, toDate: Date?) {
        let popup = PopupViewController()
        popup.delegate = self
        popup.isFromDate = isFromDate
        popup.isToDate = isToDate
        popup.fromDate = fromDate
        popup.toDate = toDate
        popup.show()
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
    override func setupViewBase() {
      super.setupViewBase()
      let alert = AlertStandard.sharedInstance
      let header = ["Content-Type":"application/x-www-form-urlencoded","hbbgvauth":"\(UserDefaultHelper.getToken()!)"]
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
        }else {
            self.reloadOwnerListViewController()
        }
    }
}
