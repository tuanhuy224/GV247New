//
//  WorkAround.swift
//  GV24
//
//  Created by admin on 5/24/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import IoniconsSwift
import Alamofire
import SwiftyJSON
import Kingfisher
import CoreLocation
import AddressBookUI

class WorkAroundController: BaseViewController {
    @IBOutlet weak var arWork: WorkAround!
    var cellHeight: CGFloat?
    var  user:User?
    var id:String?
    var isLoading:Bool = false
    var currentPage:Int = 1
    var lastPage:Int = 1
    var logtitude:Double?
    var lattitude:Double?
    var arrays = [Around]()
    var googlePlace = [GooglePlace]()
    var textLocation:String?
    var currentLocation: CLLocationCoordinate2D?
    var searchController = UISearchController(searchResultsController: nil)
    
    var work = [WorkName]()
    @IBOutlet weak var aroundTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        aroundTableView.register(UINib(nibName:NibWorkTableViewCell,bundle: nil), forCellReuseIdentifier: workCellID)
        aroundTableView.addSubview(handleRefresh)
        arWork.setupView()
        searchController.searchBar.delegate = self
        aroundTableView.separatorStyle = .none
        searchController.searchBar.tintColor = .black
        searchController.searchBar.placeholder = "SearchLocation".localize
        searchController.searchBar.barTintColor = .white
        searchController.searchBar.tintColor =  UIColor.colorWithRedValue(redValue: 47, greenValue: 186, blueValue: 194, alpha: 1)
        self.aroundTableView.rowHeight = UITableViewAutomaticDimension
        self.aroundTableView.estimatedRowHeight = 100.0
        setup()
        configSearchBar()
        loadData()
    }
    override func setupViewBase() {
        if UserDefaultHelper.getSlider() != "" {
            if UserDefaultHelper.getSlider() == nil {
                return
            }
            arWork.sliderMax.text = "\(UserDefaultHelper.getSlider()!)"
            arWork.slider.setValue(Float(UserDefaultHelper.getSlider()!)!, animated: true)
        }
    }
    func loadData() {
        loadingView.show()
        self.arrays.removeAll()
        let apiService = APIService.shared
        let param:[String:Double] = ["lng": (currentLocation?.longitude)!,"lat": (currentLocation?.latitude)!,"minDistance":0,"maxDistance":10]
        apiService.getAllAround(url: APIPaths().urlGetListAround(), method: .get, parameters: param, encoding: URLEncoding.default) { (json, string) in
            self.loadingView.close()
            if let jsonArray = json?.array{
                for data in jsonArray{
                    self.arrays.append(Around(json: data))
                }
                self.aroundTableView.reloadData()
            }
        }
    }
    func configSearchBar() {
        let subView = UIView(frame: CGRect(x: 0, y: 64.0, width:UIScreen.main.bounds.width, height: 45.0))
        subView.addSubview((searchController.searchBar))
        view.addSubview(subView)
        searchController.searchBar.sizeToFit()
        searchController.hidesNavigationBarDuringPresentation = false
    }
    lazy var handleRefresh:UIRefreshControl = {
    let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(WorkAroundController.handleRef), for: .valueChanged)
        return refresh
    }()
    func handleRef() {
        self.handleRefresh.endRefreshing()
        guard !isLoading else {return}
            isLoading = true
    }
    fileprivate func loadMore(){
        guard !isLoading else {return}
        guard currentPage < lastPage else{return}
            isLoading = true
    }
    func setup(){
        
        arWork.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Nearbyjobs".localize
        self.customBarRightButton()
    }
    func customBarRightButton(){
        let button = UIButton(type: .custom)
        button.setTitle("search".localize, for: .normal)
        button.setTitleColor(UIColor.colorWithRedValue(redValue: 47, greenValue: 186, blueValue: 194, alpha: 1), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 80, height: 30)
        button.titleLabel?.font = UIFont(descriptor: UIFontDescriptor.SemiBoldDescriptor(textStyle: UIFontTextStyle.footnote.rawValue), size: sizeSeven)
        button.addTarget(self, action: #selector(WorkAroundController.selectButton), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        
    }
    @objc fileprivate func selectButton() {
            self.loadData()
    }
    // Get longtitude and lattitue
    func forwardGeocoding(){
        loadingView.show()
        guard let locationString =  textLocation else{return}
        APIService.shared.getLocation(url: locationString) { (json, error) in
            self.loadingView.close()
            guard let geometry = json?[0]["geometry"].dictionary else{return}
            guard let location = geometry["location"]?.dictionary else{return}
            guard let lat = location["lat"], let lng = location["lng"] else{return}
            self.currentLocation?.latitude = lat.double!
            self.currentLocation?.longitude = lng.double!
        }
    }
}
extension WorkAroundController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return arrays.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell: WorkTableViewCell = (aroundTableView.dequeueReusableCell(withIdentifier: workCellID, for: indexPath) as? WorkTableViewCell)!
        cell.lbWork.text = "\(arrays[indexPath.row].id!.name!)"
        cell.amountWork.text = "\(arrays[indexPath.row].count!)"
        let image = URL(string: arrays[indexPath.row].id!.image!)
        DispatchQueue.main.async {
             cell.imageWork.kf.setImage(with: image)
        }
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let vc = AroundItemController(nibName: CTAroundItemController, bundle: nil)
            vc.id = "\(arrays[indexPath.row].id!.id!)"
            vc.name = "\(arrays[indexPath.row].id!.name!)"
            vc.currentLocation = currentLocation
            navigationController?.pushViewController(vc, animated: true)
    }
}
extension WorkAroundController:changeSliderDelegate{
    func change(slider: UISlider) {
        if slider.isContinuous == true {
            arWork.sliderMax.text = String(stringInterpolation: "\(Int(slider.value))km")
            UserDefaultHelper.setSlider(slider: "\(Int(slider.value))")
        }
    }
}
extension WorkAroundController:sendIdForViewDetailDelegate{
    func sendId(id: String) {
    }
}

extension WorkAroundController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        arrays.removeAll()
        self.textLocation = searchText
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar){
        forwardGeocoding()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadData()
    }
}



