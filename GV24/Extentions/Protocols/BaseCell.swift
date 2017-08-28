//
//  BaseCell.swift
//  GV24
//
//  Created by HuyNguyen on 7/10/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import UIKit

/**
 cell protocol for uicollectionview, uitableview
 */
protocol BaseCellProtocol {
    static func getNibName() -> String // return nibname of cell
    static func getNib() -> UINib // return nib of cell
}

/**
 default implement for cell
 */
extension BaseCellProtocol where Self : UIView {
    static func getNibName() -> String {
        return String(describing: self)
    }
    
    static func getNib() -> UINib {
        let mainBundle = Bundle.main
        return UINib.init(nibName: self.getNibName(), bundle: mainBundle)
    }
}

extension UITableView {
    func on_register< T : BaseCellProtocol>(type: T.Type)  {
        self.register(T.getNib(), forCellReuseIdentifier: T.getNibName())
        
    }
    
    func on_dequeue< T : BaseCellProtocol>(idxPath : IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.getNibName(), for: idxPath) as? T else {
            fatalError("couldnt dequeue cell with identifier \(T.getNibName())")
        }
        return cell
    }
}
