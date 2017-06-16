//
//  TableViewHelper.swift
//  GV24
//
//  Created by Macbook Solution on 6/15/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import UIKit

class TableViewHelper: NSObject {
    
    func emptyMessage(message: String, tableView: UITableView) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        label.text = message
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont(name: "TrebuchetMS", size: 17)
        label.sizeToFit()
        tableView.backgroundView = label
//        tableView.separatorStyle = .none
    }
    
    func stopActivityIndicatorView(activityIndicatorView: UIActivityIndicatorView, message: String?, tableView: UITableView, isReload:Bool) {
        DispatchQueue.main.async {
            activityIndicatorView.stopAnimating()
            if message != nil {
                TableViewHelper().emptyMessage(message: message!, tableView: tableView)
            }
            if isReload == true {
                tableView.reloadData()
            }
        }
    }
}
