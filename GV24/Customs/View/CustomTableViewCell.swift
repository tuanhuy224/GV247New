//
//  CustomTableViewCell.swift
//  GV24
//
//  Created by HuyNguyen on 6/13/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

/**
 cell protocol for uicollectionview, uitableview
 */
protocol BaseCellProtocol {
    static func getNibName() -> String // return nibname of cell
    static func getNib() -> UINib // return nib of cell
    static func getClassName() -> String
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
    static func getClassName() -> String {
        return String(describing: self)
    }
}


class CustomTableViewCell: UITableViewCell, BaseCellProtocol {
    static var identifier: String {
        return NSStringFromClass(self)
    }
    var customLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customLabel = UILabel(frame: CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height))
        customLabel.textAlignment = .center
        contentView.addSubview(customLabel)
        selectionStyle = .none
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        selectionStyle = .none
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
