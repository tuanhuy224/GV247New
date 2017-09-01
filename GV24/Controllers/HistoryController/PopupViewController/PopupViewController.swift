//
//  PopupViewController.swift
//  GV24
//
//  Created by Mark on 6/12/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

@objc protocol PopupViewControllerDelegate: class {
    func selectedDate(date: Date, isFromDate: Bool, isToDate: Bool)
    
    @objc optional func current(_ currentDate: Date)
}

class PopupViewController: BaseViewController {
    
    var delegate: PopupViewControllerDelegate?
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var effectView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var selectButton: UIButton!
    var isFromDate: Bool = false
    var isToDate: Bool = false
    var fromDate: Date?
    var toDate: Date!
    var currentDate:Date?
    @IBOutlet weak var bottomConstraintToSuperView: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPopup()
    }
    
    func setupPopup()  {
        datePicker.backgroundColor = UIColor.white
        effectView.alpha = 0
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 1, height: 1)
        containerView.layer.shadowRadius = 5
        containerView.layer.shadowOpacity = 0.7
        cancelButton.setTitle("Cancel".localize, for: .normal)
        selectButton.setTitle("Select".localize, for: .normal)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismiss(animated:)))
        effectView.addGestureRecognizer(tapGesture)
        bottomConstraintToSuperView.constant -= self.containerView.frame.size.height
        effectView.alpha = 0.0
        self.view.layoutIfNeeded()
    }
    
    func show() {
        guard let rootController = UIApplication.shared.keyWindow?.rootViewController else {return}
        view.frame = rootController.view.bounds
        rootController.view.addSubview(view)
        self.willMove(toParentViewController: rootController)
        rootController.addChildViewController(self)
        self.didMove(toParentViewController: rootController)
        
        
        // animation
        UIView.animate(withDuration: 0.24, animations: {
            // move constraint correctly
            self.bottomConstraintToSuperView.constant = 0
            self.effectView.alpha = 0.5
            self.view.layoutIfNeeded()
            
        }) { (success) in
            //  do nothing
        }
        
    }
    
    func dismiss(animated: Bool = false) {
        
        if animated {
            // animation
            UIView.animate(withDuration: 0.24, animations: {
                self.bottomConstraintToSuperView.constant -= self.containerView.frame.size.height
                self.effectView.alpha = 0
                self.view.layoutIfNeeded()
            }, completion: { (completed) in
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
            })
        }
        
    }
    
    @IBAction func selectDate(_ sender: Any) {
        if isFromDate == true {
            if datePicker.date.compare(toDate) == ComparisonResult.orderedAscending || String.convertDateToString(date: datePicker.date, withFormat: "dd/MM/yyyy") == String.convertDateToString(date: toDate, withFormat: "dd/MM/yyyy") {
                print("aaa: ascending")
                doDismiss(date: Date().date(datePicker.date), isFromDate: true, isToDate: false)
                
                
            }else {
                print("aaa: descending")
                let alertController = AlertHelper.sharedInstance.showAlertError(title: "Notification".localize, message: "PleaseSelectTheStartDateLessThanOrEqualTheEndDate".localize)
                present(alertController, animated: true, completion: nil)
            }
            
            
        }else {
            if fromDate == nil {
                doDismiss(date: Date().date(datePicker.date), isFromDate: false, isToDate: true)
                
                currentDate = Date().date(datePicker.date)
            }else {
                
                
                if datePicker.date.compare(fromDate!) == ComparisonResult.orderedDescending || String.convertDateToString(date: datePicker.date, withFormat: "dd/MM/yyyy") == String.convertDateToString(date: toDate, withFormat: "dd/MM/yyyy") {
                    print("bbb: descending")
                    doDismiss(date: Date().date(datePicker.date), isFromDate: false, isToDate: true)
                }else {
                    print("bbb: ascending")
                    let alertController = AlertHelper.sharedInstance.showAlertError(title: "Notification".localize, message: "PleaseSelectTheEndDateGreaterThanOrEqualTheStartDate".localize)
                    present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        effectView.alpha = 0
        self.dismiss(animated: true)
    }
    
    fileprivate func doDismiss(date: Date, isFromDate: Bool, isToDate: Bool) {
        effectView.alpha = 0
        self.dismiss(animated: true)
        self.delegate?.selectedDate(date: date, isFromDate: isFromDate, isToDate: isToDate)

    }
    
    override func setupViewBase() {}
    
    override func decorate() {}
    
}
