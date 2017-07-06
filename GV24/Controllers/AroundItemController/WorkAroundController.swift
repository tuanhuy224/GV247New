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
    lazy var geocoder = CLGeocoder()
    var googlePlace = [GooglePlace]()
    var textLocation:String?
    var currentLocation: CLLocationCoordinate2D?
   // var searchController = UISearchController(searchResultsController: nil)
    var searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
    var work = [WorkName]()
    @IBOutlet weak var aroundTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        aroundTableView.register(UINib(nibName:NibWorkTableViewCell,bundle: nil), forCellReuseIdentifier: workCellID)
        aroundTableView.addSubview(handleRefresh)
        arWork.setupView()
        searchBar.delegate = self
        //        aroundTableView.separatorStyle = .none
        searchBar.placeholder = "SearchLocation".localize
        searchBar.barTintColor = .white
        searchBar.tintColor =  UIColor.colorWithRedValue(redValue: 47, greenValue: 186, blueValue: 194, alpha: 1)
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
            arWork.sliderMax.text = "\(UserDefaultHelper.getSlider()!)km"
            arWork.slider.setValue(Float(UserDefaultHelper.getSlider()!)!, animated: true)
        }
    }
    func loadData() {
        loadingView.show()
        let apiService = APIService.shared
        let param:Parameters = ["lng": (currentLocation?.longitude)!,"lat": (currentLocation?.latitude)!,"minDistance":0,"maxDistance":10]
        apiService.getAllAround(url: APIPaths().urlGetListAround(), method: .get, parameters: param, encoding: URLEncoding.default) { (json, string) in
            // success
            if let jsons = json?.array{
                let works = jsons.map({ (json) -> Around in
                    return Around(json: json)
                })
                self.arrays = works
                self.aroundTableView.reloadData()
            }
            // failure
            else {
                let alert = AlertStandard.sharedInstance
                alert.showAlert(controller: self, title: "", message: "notResultFound".localize)
                self.arrays = []
                self.aroundTableView.reloadData()
            }
            self.loadingView.close()
        }
    }
    func configSearchBar() {
        let subView = UIView(frame: CGRect(x: 0, y: 0, width:UIScreen.main.bounds.width, height: 45.0))
        subView.addSubview(searchBar)
        view.addSubview(subView)
        searchBar.sizeToFit()
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
        searchBar.resignFirstResponder()
        guard let searchTextChange = textLocation else{return}
        searchText(text: searchTextChange)
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
    func handle(location : CLLocationCoordinate2D){
        self.currentLocation = location
    }
    func searchText(text:String) {
        geocoder.geocodeAddressString(text) { (placeMarks, error) in
            self.loadingView.close()
            if error == nil{
                if (placeMarks?.count)! > 0{
                    guard let firstLocation = placeMarks?.first?.location else{return}
                    self.handle(location: firstLocation.coordinate)
                }else{
                    
                }
            }else{
                AlertStandard.sharedInstance.showAlert(controller: self, title: "", message: "Somethingwentwrong".localize)
            }
        }
    }
}
extension WorkAroundController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrays.count == 0 {
            return 0
        }
         return arrays.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell: WorkTableViewCell = (aroundTableView.dequeueReusableCell(withIdentifier: workCellID, for: indexPath) as? WorkTableViewCell)!
        let index = arrays[indexPath.row]
        let id = index.id?.name ?? ""
        let amount = index.count ?? 0
        cell.lbWork.text = "\(id)"
        cell.amountWork.text = "\(amount)"
        let image = URL(string: arrays[indexPath.row].id!.image!)
        cell.imageWork.kf.setImage(with: image)
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let vc = AroundItemController(nibName: CTAroundItemController, bundle: nil)
        let index = arrays[indexPath.row]
        let id = index.id?.id ?? ""
        let name = index.id?.name ?? ""
            vc.id = "\(id)"
            vc.name = "\(name)"
            vc.currentLocation = currentLocation
            navigationController?.pushViewController(vc, animated: true)
    }
}


let stepper = 1
extension WorkAroundController:changeSliderDelegate{
    func change(slider: UISlider) {
        let value = round(slider.value / Float(stepper))
        let step = value * Float(stepper)
        arWork.sliderMax.text = String(stringInterpolation: "\(Int(step))km")
        arWork.slider.value = value
        UserDefaultHelper.setSlider(slider: "\(Int(step))")
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
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        arrays.removeAll()
        searchBar.resignFirstResponder()
        guard let text = self.textLocation else{return}
        searchText(text: text)
        self.loadData()
    }
}



