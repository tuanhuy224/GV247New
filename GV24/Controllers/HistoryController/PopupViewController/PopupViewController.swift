//
//  PopupViewController.swift
//  GV24
//
//  Created by Mark on 6/12/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

protocol PopupViewControllerDelegate: class {
    func selectedDate(date: Date, isFromDate: Bool, isToDate: Bool)
}

class PopupViewController: BaseViewController {

    var delegate: PopupViewControllerDelegate?
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var effectView: UIView!
    var isFromDate: Bool = false
    var isToDate: Bool = false
    var fromDate: Date?
    var toDate: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        datePicker.backgroundColor = UIColor.white
        effectView.alpha = 0
    }
    
    @IBAction func selectDate(_ sender: Any) {
        if isFromDate == true {
            if datePicker.date.compare(toDate) == ComparisonResult.orderedAscending || String.convertDateToString(date: datePicker.date, withFormat: "dd/MM/yyyy") == String.convertDateToString(date: toDate, withFormat: "dd/MM/yyyy") {
                print("aaa: ascending")
                doDismiss(date: datePicker.date, isFromDate: true, isToDate: false)
            }
            else {
                print("aaa: descending")
                let alertController = AlertHelper.sharedInstance.showAlertError(title: "Message", message: "Please select begin date lesser than\nor equal to end date.")
                present(alertController, animated: true, completion: nil)
            }
        }
        else {
            if fromDate == nil {
                doDismiss(date: datePicker.date, isFromDate: false, isToDate: true)
            }
            else {
                if datePicker.date.compare(fromDate!) == ComparisonResult.orderedDescending || String.convertDateToString(date: datePicker.date, withFormat: "dd/MM/yyyy") == String.convertDateToString(date: toDate, withFormat: "dd/MM/yyyy") {
                    print("bbb: descending")
                    doDismiss(date: datePicker.date, isFromDate: false, isToDate: true)
                }
                else {
                    print("bbb: ascending")
                    let alertController = AlertHelper.sharedInstance.showAlertError(title: "Message", message: "Please select end date greater than\nor equal to begin date.")
                    present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        effectView.alpha = 0
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func doDismiss(date: Date, isFromDate: Bool, isToDate: Bool) {
        effectView.alpha = 0
        self.dismiss(animated: true, completion: nil)
        delegate?.selectedDate(date: date, isFromDate: isFromDate, isToDate: isToDate)
    }
    
    override func setupViewBase() {}
    
    override func decorate() {}

}
