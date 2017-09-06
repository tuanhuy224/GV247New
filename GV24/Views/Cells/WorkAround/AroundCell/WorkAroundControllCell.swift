//
//  WorkAroundControllCell.swift
//  GV24
//
//  Created by dinhphong on 8/28/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import UIKit

protocol WorkAroundDelegate {
    func scrollDragWorkAround(cell index: Int)
}
class WorkAroundControllCell : UICollectionViewCell {
    
    var nearByWork: NearbyWork? {
        didSet {
            self.collectionWorkAround.reloadData()
        }
    }
    
    var currentLocation: CLLocationCoordinate2D?
    
    var delegate: WorkAroundDelegate?
    
    
    let nearbyWorkCellId = "nearbyWorkCellId"
    let mapWorkCellId = "mapWorkCellId"
    
    
    lazy var collectionWorkAround : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.dataSource = self
        cv.isPagingEnabled = true
        return cv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
        collectionWorkAround.register(NearbyWorkControllCell.self, forCellWithReuseIdentifier: nearbyWorkCellId)
        collectionWorkAround.register(MapWorkControllCell.self, forCellWithReuseIdentifier: mapWorkCellId)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.addSubview(collectionWorkAround)
        
        self.addConstraintWithFormat(format: "H:|[v0]|", views: collectionWorkAround)
        self.addConstraintWithFormat(format: "V:|[v0]|", views: collectionWorkAround)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / self.frame.width
        delegate?.scrollDragWorkAround(cell: Int(index))
    }
    
    
}
extension WorkAroundControllCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: nearbyWorkCellId, for: indexPath) as! NearbyWorkControllCell
            cell.nearByWork = nearByWork
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mapWorkCellId, for: indexPath) as! MapWorkControllCell
            cell.nearByWork = nearByWork
            cell.currentLocation = currentLocation
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: self.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
