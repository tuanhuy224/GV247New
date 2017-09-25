//
//  PageViewController.swift
//  GV24
//
//  Created by HuyNguyen on 9/21/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class PageViewController: BaseViewController {
    
    var lbView = UILabel()
    @IBOutlet weak var viewPage: UIView!
    @IBOutlet weak var sControl: UIView!
    var selectIndex: Int = 0 {
        didSet{
            print(selectIndex)
        }
    }
    var segmentControl =  SegmentedControl(frame: .zero, titles: ["waiting".localize,
                                                                  "assigned".localize,"runnning".localize])
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
        return [WaittingController(), AssignController(), RunningController()]
    }()
    
    override func setupViewBase() {
        super.setupViewBase()
        self.title = "Titlemanagement".localize
        pageController.dataSource = self
        pageController.delegate = self
        if let first = page.first {
            pageController.setViewControllers([first], direction: .forward, animated: false, completion: nil)
        }
        
        sControl.addSubview(segmentControl)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraintWithFormat(format: "H:|[v0]|", views: segmentControl)
        view.addConstraintWithFormat(format: "V:|[v0(35)]", views: segmentControl)
        segmentControl.delegate = self
        
        
        
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        viewPage.frame = CGRect(x: 0, y: 0, width: screenWidth, height: height)
        viewPage.addSubview(pageController.view)
        viewPage.backgroundColor = .groupTableViewBackground
        addChildViewController(pageController)
        sControl.layer.cornerRadius = 8
        sControl.layer.masksToBounds = true
        sControl.layer.borderColor = AppColor.backButton.cgColor
        sControl.layer.borderWidth = 1
        
    }
}

extension PageViewController: UIPageViewControllerDelegate{
    
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

extension PageViewController: UIPageViewControllerDataSource{
    
    
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

extension PageViewController:SegmentedControlDelegate{
    func segmentedControl(_ segmentedControl: SegmentedControl, willPressItemAt index: Int){}
    func segmentedControl(_ segmentedControl: SegmentedControl, didPressItemAt index: Int){
        vIndex = page[index]
        selectIndex = index
        var direction: UIPageViewControllerNavigationDirection = .forward
        if index == 0 {
            direction = .reverse
        }else{
            direction = .forward
        }
        pageController.setViewControllers([vIndex], direction: direction, animated: true, completion: nil)
    }
}
