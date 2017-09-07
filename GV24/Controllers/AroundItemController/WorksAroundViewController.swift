//
//  WorksAroundViewController.swift
//  GV24
//
//  Created by dinhphong on 8/28/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import UIKit



class WorksAroundViewController : BaseViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var currentLocation : CLLocationCoordinate2D?
    
    var nearbyWork: NearbyWork?
    var distanceWork = DistanceWork()
    var maxDistance = 5
    
   lazy var collectionType : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
        return cv  
    }()
    
    let segmentedControl : UISegmentedControl = {
        let sc = UISegmentedControl()
        sc.insertSegment(withTitle: "List", at: 0, animated: true)
        sc.insertSegment(withTitle: "Map", at: 1, animated: true)
        sc.selectedSegmentIndex = 0
        sc.tintColor = UIColor(red: 51/255, green: 197/255, blue: 205/255, alpha: 1)
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    let cellId = "cellId"
    let headerId = "headerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
        title = "Nearbyjobs".localize
        setupView()
        
        segmentedControl.addTarget(self, action: #selector(segmentValueChange(_:)), for: .valueChanged)
        collectionType.register(WorkAroundControllCell.self, forCellWithReuseIdentifier: cellId)
        collectionType.register(HeaderWithTitle.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        
        setupLocationManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    deinit {
        print("Release!!!!!!!!!!!!!!")
    }
    
    
    private func setupLocationManager() {
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.delegate = self
        if (CLLocationManager.locationServicesEnabled()) {
            if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways{
                locationManager.startUpdatingLocation()
            }
            else{
                let alertController = UIAlertController (title: "",
                                                         message: "Cài đặt vị trí", preferredStyle: .alert)
                
                let settingsAction = UIAlertAction(title: "Settings",
                                                   style: .default) { (_) -> Void in
                                                    guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                                                        return
                                                    }
                                                    if UIApplication.shared.canOpenURL(settingsUrl) {
                                                        UIApplication.shared.openURL(settingsUrl)
                                                    }
                }
                alertController.addAction(settingsAction)
                let cancelAction = UIAlertAction(title: "Cancel",
                                                 
                                                 style: .cancel, handler: {(_) -> Void in
                                           
                })
                alertController.addAction(cancelAction)
                
                present(alertController, animated: true, completion: nil)
            }
        }

    }
    
    //MARK: - Location manager delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        guard let coordinate = manager.location?.coordinate  else {
            return
        }
        currentLocation = coordinate
        self.loadNearByWork(maxDistance, 1) { (nearByWork) in
            self.nearbyWork = nearByWork
            self.collectionType.reloadData()
        }
    }
    
    func loadNearByWork(_ maxDistance: Int,_ page: Int, completion: @escaping (NearbyWork?) -> ()){
        let parameter :[String:Any] = ["lat": currentLocation?.latitude,
                                       "lng": currentLocation?.longitude,
                                       "maxDistance": maxDistance,
                                       "page": page,
                                       "limit": 10]
        loadingView.show()
        AroundTask.sharedInstall.getWorkAround(APIPaths().getTaskByAround(), parameter) { (nearbyWork, error) in
            self.loadingView.close()
            if let nearbyWork = nearbyWork {
                completion(nearbyWork)
            }else{
                completion(nil)
            }
        }
    }
    
    func setupView() {
        view.addSubview(segmentedControl)
        view.addSubview(collectionType)
        
        view.addConstraintWithFormat(format: "V:|-10-[v0(30)]-10-[v1]|", views: segmentedControl, collectionType)
        view.addConstraintWithFormat(format: "H:|-\(15)-[v0]-\(15)-|", views: segmentedControl)
        view.addConstraintWithFormat(format: "H:|[v0]|", views: collectionType)
    }
    
    func segmentValueChange(_ sender: UISegmentedControl) {
        let cell = collectionType.cellForItem(at: IndexPath(item: 0, section: 0)) as! WorkAroundControllCell
        DispatchQueue.main.async {
            cell.collectionWorkAround.scrollToItem(at: IndexPath(item: sender.selectedSegmentIndex, section: 0), at: .left, animated: true)
        }
    }
}


extension WorksAroundViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! WorkAroundControllCell
        cell.nearByWork = nearbyWork
        cell.currentLocation = currentLocation
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height - 100)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.size.width, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! HeaderWithTitle
        headerView.delegate = self
        headerView.title = "Vị trí: \(distanceWork.nameLocation ?? ""), Khoảng cách: \(distanceWork.distance ?? ""), Loại công việc: \(distanceWork.workType ?? "")"
        return headerView
    }
}


extension WorksAroundViewController: WorkAroundDelegate {
    func scrollDragWorkAround(cell index: Int) {
        segmentedControl.selectedSegmentIndex = index
    }
}

extension WorksAroundViewController: SettingHeaderDelegate {
    func nearByWork(buttonSetting sender: UIButton) {
        let filterVC = FilterWorkController()
        filterVC.distanceWork = distanceWork
        filterVC.currentLocation = currentLocation
        filterVC.maxDistance = maxDistance
        filterVC.delegate = self
        self.navigationController?.pushViewController(filterVC, animated: true)
        print("Handle Filter Near By Work")
    }
}

extension WorksAroundViewController: FilterVCDelegate {
    func update(_ nearbyWork: NearbyWork?, distanceWork: DistanceWork, currentLocation: CLLocationCoordinate2D) {
        self.nearbyWork = nearbyWork
        self.distanceWork = distanceWork
        self.currentLocation = currentLocation
        self.collectionType.reloadData()
    }
}
