//
//  NearbyWorkControllCell.swift
//  GV24
//
//  Created by dinhphong on 8/29/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import UIKit

protocol NearbyWorkDelegateCell {
    
    func didSelected(_ collectionView: UICollectionView, work: Work)
}
class NearbyWorkControllCell: UICollectionViewCell {
    
    var delegate: NearbyWorkDelegateCell?
    
    var nearByWork: NearbyWork? {
        didSet{
            self.workCollectionView.reloadData()
        }
    }
    
    let workAroundCellId = "workAroundCellId"
    lazy var workCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.addSubview(workCollectionView)
        
        self.addConstraintWithFormat(format: "H:|[v0]|", views: workCollectionView)
        self.addConstraintWithFormat(format: "V:|[v0]|", views: workCollectionView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        workCollectionView.register(WorkAroundCell.self, forCellWithReuseIdentifier: workAroundCellId)
    }
    
    
}
extension NearbyWorkControllCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nearByWork?.works?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: workAroundCellId, for: indexPath) as! WorkAroundCell
        cell.work = nearByWork?.works?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.size.width, height: 90)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let work = nearByWork?.works?[indexPath.item] {
            delegate?.didSelected(collectionView, work: work)
        }
        
        
    }

}
