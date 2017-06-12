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

class PopupViewController: UIViewController {

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
            if datePicker.date.compare(toDate) == ComparisonResult.orderedAscending {
                print("aaa: ascending")
                dismiss()
                delegate?.selectedDate(date: datePicker.date, isFromDate: true, isToDate: false)
            }
            else {
                print("aaa: descending")
                showAlert(title: "Message", message: "The selected date must be less than the to date.")
            }
        }
        else {
            if fromDate == nil {
                dismiss()
                delegate?.selectedDate(date: datePicker.date, isFromDate: false, isToDate: true)
            }
            else {
                if datePicker.date.compare(fromDate!) == ComparisonResult.orderedDescending {
                    print("bbb: descending")
                    dismiss()
                    delegate?.selectedDate(date: datePicker.date, isFromDate:  false, isToDate: true)
                }
                else {
                    print("bbb: ascending")
                    showAlert(title: "Message", message: "The selected date must be greater than the from date.")
                }
            }
        }
        
    }
    
    fileprivate func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss()
    }
    
    fileprivate func dismiss() {
        effectView.alpha = 0
        self.dismiss(animated: true, completion: nil)
    }

}
