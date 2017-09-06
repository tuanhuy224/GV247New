//
//  FilterWorkViewController.swift
//  GV24
//
//  Created by dinhphong on 8/30/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import UIKit
import GooglePlacePicker

protocol FilterVCDelegate {
    func update(_ nearbyWork : NearbyWork?, distanceWork: DistanceWork, currentLocation: CLLocationCoordinate2D)
}

class FilterWorkController: BaseViewController {
    
    var delegate: FilterVCDelegate?
    var currentLocation: CLLocationCoordinate2D?
    var distanceWork: DistanceWork?
    var workType: WorkType?
    var maxDistance: Int?
    
    let cellId = "cellId"
    
    lazy var tableFilterWork: UITableView = {
        let tbv = UITableView()
        tbv.translatesAutoresizingMaskIntoConstraints = false
        tbv.backgroundColor = .clear
        tbv.separatorStyle = .singleLine
        tbv.isScrollEnabled = false
        tbv.dataSource = self
        tbv.delegate = self
        return tbv
    }()
    
    private let updateButton : UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Cập nhật", for: .normal)
        btn.backgroundColor = UIColor(red: 51/255, green: 197/255, blue: 205/255, alpha: 1)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        title = "Tìm kiếm nâng cao"
        setupView()
        tableFilterWork.register(FilterControllCell.self, forCellReuseIdentifier: cellId)
        updateButton.addTarget(self, action: #selector(handleupdateButton(_:)), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setupView() {
        self.view.addSubview(tableFilterWork)
        self.view.addSubview(updateButton)
        
        view.addConstraintWithFormat(format: "H:|[v0]|", views: tableFilterWork)
        view.addConstraintWithFormat(format: "V:|[v0(132)]-20-[v1(45)]", views: tableFilterWork, updateButton)
        
        updateButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        updateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
    }
    
    func handleupdateButton(_ sender: UIButton) {
        loadNearByWork(maxDistance!, 1) { (nearbyWork) in
            self.delegate?.update(nearbyWork, distanceWork: self.distanceWork!, currentLocation: self.currentLocation!)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func loadNearByWork(_ maxDistance: Int,_ page: Int, completion: @escaping (NearbyWork?) -> ()){
        let parameter :[String:Any]
        
        if let work = workType {
            parameter = ["lat": currentLocation?.latitude,
                         "lng": currentLocation?.longitude,
                         "maxDistance": maxDistance,
                         "work": workType?.id ?? "",
                         "page": page,
                         "limit": 10]
        }else {
            parameter = ["lat": currentLocation?.latitude,
                         "lng": currentLocation?.longitude,
                         "maxDistance": maxDistance,
                         "page": page,
                         "limit": 10]
        }
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

}

extension FilterWorkController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! FilterControllCell
        switch indexPath.item {
        case 0:
            cell.title = "Vị trí"
            cell.status = (distanceWork?.nameLocation)!
        case 1:
            cell.title = "Khoảng cách"
            cell.status = (distanceWork?.distance)!
        case 2:
            cell.title = "Loại công việc"
            cell.status = (distanceWork?.workType)!
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            let config = GMSPlacePickerConfig(viewport: nil)
            let placePicker = GMSPlacePickerViewController(config: config)
            placePicker.delegate = self
            present(placePicker, animated: true, completion: nil)
        case 1:
            let distanceVC = DistanceViewController()
            distanceVC.delegate = self
            self.navigationController?.pushViewController(distanceVC, animated: true)
        case 2:
            let workTypeVC = WorkTypeViewController()
            workTypeVC.delegate = self
            self.navigationController?.pushViewController(workTypeVC, animated: true)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
}

extension FilterWorkController: GMSPlacePickerViewControllerDelegate {
    
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        let cell = tableFilterWork.cellForRow(at: IndexPath(item: 0, section: 0)) as! FilterControllCell
        cell.status = place.name
        currentLocation = place.coordinate
        distanceWork?.nameLocation = place.name
        self.dismiss(animated: true, completion: nil)
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}
extension FilterWorkController: DistanceDelegate {
    func selected(_ tableDistance: UITableView, at index: IndexPath) {
        let cell = tableFilterWork.cellForRow(at: IndexPath(item: 1, section: 0)) as! FilterControllCell
        cell.status = "\(index.item) km"
        distanceWork?.distance = "\(index.item) km"
        maxDistance = index.item
    }
}

extension FilterWorkController: WorkTypeDelegate {
    func selected(_ tableWorkType: UITableView, _ work: WorkType?) {
        let cell = tableFilterWork.cellForRow(at: IndexPath(item: 2, section: 0)) as! FilterControllCell
        cell.status = work?.name ?? "Tất cả"
        distanceWork?.workType = work?.name ?? "Tất cả"
        self.workType = work
    }
}
