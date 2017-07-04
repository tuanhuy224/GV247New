//
//  WorkInfoCell.swift
//  GV24
//
//  Created by Macbook Solution on 6/19/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import IoniconsSwift
import Kingfisher

class WorkInfoCell: CustomTableViewCell {
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imgIcon: UIImageView!
    
    var data = [WorkType]() {
        didSet {
            collectionView.reloadData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        topLabel.text = "WorkCapacity".localize.uppercased()
        imgIcon.image = Ionicons.socialUsd.image(32).maskWithColor(color: UIColor.colorWithRedValue(redValue: 48, greenValue: 199, blueValue: 209, alpha: 1))
        setupCollectionView()
    }
    func setupCollectionView() {
        let nib = UINib(nibName: "WorkInfoCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: workInfoCollectionCellID)
        collectionView.delegate = self
        collectionView.dataSource = self
         priceLabel.font = UIFont(descriptor: UIFontDescriptor.preferredDescriptor(textStyle: UIFontTextStyle.headline.rawValue), size: 14)
         topLabel.font = UIFont(descriptor: UIFontDescriptor.BoldDescriptor(textStyle: UIFontTextStyle.headline.rawValue), size: 17)
    }
}
extension WorkInfoCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: workInfoCollectionCellID, for: indexPath) as! WorkInfoCollectionViewCell
        let workType = data[indexPath.row]
        cell.titleLabel.text = workType.name
        cell.titleLabel.font = UIFont(descriptor: UIFontDescriptor.preferredDescriptor(textStyle: UIFontTextStyle.headline.rawValue), size: 14)
        cell.titleLabel.numberOfLines = 0
        
        if let imageString = workType.image {
            let url = URL(string: imageString)
            cell.icon.kf.setImage(with: url, placeholder: UIImage(named: "nau an"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        cell.delegate = self
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
extension WorkInfoCell:disSelectIndexPathDelegate{
    func didSelect(index: Any) {
        let buttonPosition:CGPoint = (index as AnyObject).convert(.zero, to:self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: buttonPosition)
        print(indexPath!)
    
    }



}
