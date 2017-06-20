//
//  WorkInfoCell.swift
//  GV24
//
//  Created by Macbook Solution on 6/19/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import IoniconsSwift

class WorkInfoCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imgIcon: UIImageView!
    var data: [String] = []{
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgIcon.image = Ionicons.socialUsd.image(15).maskWithColor(color: UIColor.colorWithRedValue(redValue: 48, greenValue: 199, blueValue: 209, alpha: 1))
        setupCollectionView()
    }
    
    func setupCollectionView() {
        let nib = UINib(nibName: "WorkInfoCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: workInfoCollectionCellID)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
        cell.titleLabel.text = data[indexPath.row]
        return cell
    }
}
