//
//  ManagerHistoryViewController.swift
//  GV24
//
//  Created by admin on 6/9/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class ManagerHistoryViewController: BaseViewController {
    
    @IBOutlet weak var sSegment: UIView!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var toDateButton: UIButton!
    @IBOutlet weak var fromDateButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    
    var firstFromDate: Date? = nil
    var firstToDate: Date = Date()
    var secondFromDate : Date? = nil
    var secondToDate : Date = Date()
    
    var currentSelectedIndex: Int = 0
    var isFirstTime: Bool = true
    var isDisplayAlert:Bool = false
    var billId:String?
    
    var workListVC = HistoryViewController()
    var ownerListVC = OwnerHistoryViewController()
    
    var selectIndex: Int = 0 {
        didSet{
            print(selectIndex)
        }
    }
    var segmentControl =  SegmentedControl(frame: .zero, titles: ["CompleteW".localize,
                                                                  "Formerpartners".localize])
    var vIndex = UIViewController()
    var index: Int = 0
    var indexCell: Int?{
        didSet{
            guard let indexPage = indexCell else {return}
            UIView.animate(withDuration: 1, animations: {
                self.pageController.setViewControllers([self.page[indexPage]], direction: .forward, animated: true, completion: nil)
            })
        }
    }
    
    lazy var pageController: UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        return pageViewController
    }()
    
    lazy var page: [UIViewController] = {
        return [HistoryViewController(), OwnerHistoryViewController()]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        customNavigationController()
        setupContainerView()
        setupConstrains()

        pageController.dataSource = self
        pageController.delegate = self
        if let first = page.first {
            pageController.setViewControllers([first], direction: .forward, animated: false, completion: nil)
        }
        sSegment.addSubview(segmentControl)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraintWithFormat(format: "H:|[v0]|", views: segmentControl)
        view.addConstraintWithFormat(format: "V:|[v0(30)]", views: segmentControl)
        segmentControl.delegate = self
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        containerView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: height)
        containerView.addSubview(pageController.view)
        addChildViewController(pageController)
        sSegment.layer.cornerRadius = 8
        sSegment.layer.masksToBounds = true
        sSegment.layer.borderColor = AppColor.backButton.cgColor
        sSegment.layer.borderWidth = 1
        fromDateButton.tintColor = AppColor.backButton
        toDateButton.tintColor = AppColor.backButton
    }
    

    func customNavigationController() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        //self.automaticallyAdjustsScrollViewInsets = false
    }
    
    func setupContainerView() {
        containerView.addSubview((workListVC.view)!)
        workListVC.view.tag = 0
    }
    func setupOwnerHistory() {
        containerView.addSubview((ownerListVC.view)!)
        ownerListVC.view.tag = 1
        ownerListVC.view.isHidden = true
        ownerListVC.myParent = self
    }
    
    func setupConstrains() {
        workListVC.myParent = self
        toDateButton.setTitle(Date.convertDateToString(date: Date()), for: .normal)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "WorkHistory".localize
    }

    @IBAction func fromDateButtonClicked(_ sender: Any) {
        selectIndex == 0 ? showPopup(isFromDate: true, fromDate: firstFromDate, toDate: firstToDate) : showPopup(isFromDate: true, fromDate: secondFromDate, toDate: secondToDate)
    }
    
    @IBAction func toDateButtonClicked(_ sender: UIButton) {
        selectIndex == 0 ? showPopup(isFromDate: false, fromDate: firstFromDate, toDate: firstToDate) : showPopup(isFromDate: false, fromDate: secondFromDate, toDate: secondToDate)
    }
    
    fileprivate func showPopup(isFromDate: Bool, fromDate: Date?, toDate: Date?) {
        let popup = PopupViewController()
        popup.delegate = self
        popup.isFromDate = isFromDate
        popup.fromDate = fromDate
        popup.toDate = toDate
        popup.show()
    }
    
    func listHistory() {
        workListVC.workList.removeAll()
        workListVC.historyTableView.reloadData()
        workListVC.startAtDate = firstFromDate
        workListVC.endAtDate = firstToDate
        workListVC.page = 1
        workListVC.getWorkList(startAt: firstFromDate, endAt: firstToDate)
    }
    
    func listOwnerHistory() {
        ownerListVC.ownerList.removeAll()
        ownerListVC.tableView.reloadData()
        ownerListVC.startAtDate = secondFromDate
        ownerListVC.endAtDate = secondToDate
        ownerListVC.getOwnerList(startAt: secondFromDate, endAt: secondToDate)
    }
    
    
    
    // MARK: - notification when recieved push from owner to yayment in cash
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
            if selectIndex == 0 {
                fromDateButton.setTitle(Date.convertDateToString(date: date), for: .normal)
                firstFromDate = date
            } else {
                fromDateButton.setTitle(Date.convertDateToString(date: date), for: .normal)
                secondFromDate = date
            }
        } else {
            if selectIndex == 0 {
                toDateButton.setTitle(Date.convertDateToString(date: date), for: .normal)
                firstToDate = date
            } else {
                toDateButton.setTitle(Date.convertDateToString(date: date), for: .normal)
                secondToDate = date
            }
        }
        
        if selectIndex == 0 {
            self.listHistory()
        }else {
            self.listOwnerHistory()
        }
    }
}




extension ManagerHistoryViewController: UIPageViewControllerDelegate{
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return page.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let first = page.first, let firstIndex = page.index(of: first) else {
            return 0
        }
        return firstIndex
    }
}


extension ManagerHistoryViewController: UIPageViewControllerDataSource{
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = page.index(of: viewController) else{return nil}
        if index == 0 {
            return nil
        }
        let previousIndex = abs((index - 1) % page.count)
        return page[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = page.index(of: viewController) else{return nil}
        if index == page.count-1 {
            return nil
        }
        let nextIndex = abs((index + 1) % page.count)
        return page[nextIndex]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed == false {
            guard let targetPage = previousViewControllers.first else {return}
            guard let targetIndex = page.index(of: targetPage) else {return}
            segmentControl.selectItem(at: targetIndex, withAnimation: true)
            pageController.setViewControllers(previousViewControllers, direction: .reverse, animated: true, completion: nil)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let targetPage = pendingViewControllers.first else {return}
        guard let targetIndex = page.index(of: targetPage) else {return}
        segmentControl.selectItem(at: targetIndex, withAnimation: true)
        
    }
    
    
}


extension ManagerHistoryViewController: SegmentedControlDelegate{
    func segmentedControl(_ segmentedControl: SegmentedControl, willPressItemAt index: Int){}
    func segmentedControl(_ segmentedControl: SegmentedControl, didPressItemAt index: Int){
        vIndex = page[index]
        selectIndex = index
        
        if selectIndex == 1 {
            workListVC.view.isHidden = true
            ownerListVC.view.isHidden = false
            if let date = secondFromDate {
                fromDateButton.setTitle(Date.convertDateToString(date: date), for: .normal)
            }
            toDateButton.setTitle(Date.convertDateToString(date: secondToDate), for: .normal)
            
            self.listOwnerHistory()
        }else {
            workListVC.view.isHidden = false
            ownerListVC.view.isHidden = true
            if let date = firstFromDate {
                fromDateButton.setTitle(Date.convertDateToString(date: date), for: .normal)
            }
            toDateButton.setTitle(Date.convertDateToString(date: firstToDate), for: .normal)
            
            self.listHistory()
        }
        var direction: UIPageViewControllerNavigationDirection = .forward
        if index == 0 {
            direction = .reverse
        }else{
            direction = .forward
        }
        pageController.setViewControllers([vIndex], direction: direction, animated: true, completion: nil)
    }
}
