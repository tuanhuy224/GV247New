//
//  Extenstions.swift
//  AutoKeyboard
//
//  Created by chanonly123 on 5/27/17.
//  Copyright © 2017 chanonly123. All rights reserved.
//

import UIKit

fileprivate var savedConstant:[UIViewController:[NSLayoutConstraint:CGFloat]] = [:]

extension UIViewController {
    
    public func registerAutoKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    public func unRegisterAutoKeyboard() {
        self.view.endEditing(true)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        savedConstant.removeValue(forKey: self)
        
    }
    func keyboard(constraint:NSLayoutConstraint) -> NSLayoutConstraint {
        let contraint = NSLayoutConstraint()
        return contraint
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.view.bounds.origin.y = keyboardFrame.size.height
        })
    }
    func keyboardWillHide(notification: NSNotification) {
        self.view.bounds.origin.y = 0
    }
}

