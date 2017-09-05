//
//  MapWorkControllCell.swift
//  GV24
//
//  Created by dinhphong on 8/29/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class MapWorkControllCell: UICollectionViewCell, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    var nearByWork: NearbyWork? {
        didSet{
            reloadMap()
        }
    }

    lazy var mapView : GMSMapView = {
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 16.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.delegate = self
        return mapView
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView() {
        self.addSubview(mapView)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        mapView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        mapView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        mapView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
    }
    
    //MARK: - mapview delegate
    
    func addMarkerFor(work : Work, at index : String ){
        let marker : GMSMarker = GMSMarker(position: (work.info?.address?.location)!)
        marker.title = index
        marker.map = self.mapView
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let index = Int(marker.title!)
        let window = MarkerInfoView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        window.work = nearByWork?.works?[index!]
        return window
    }
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        /*if UserHelpers.isLogin{
            if let index = Int(marker.title!){
                let maidProfileVC = MaidProfileVC()
                maidProfileVC.maid = maids?[index]
                self.present(viewController: maidProfileVC)
            }
        }else{
            showAlertLogin()
        }*/
        
    }
    func reloadMap(){
        self.mapView.clear()
        var index = 0
        for work in (nearByWork?.works)! {
            self.addMarkerFor(work: work, at: "\(index)")
            index += 1
        }
    }
}
