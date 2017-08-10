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
    var user:User?
    var id:String?
    var isLoading:Bool = false
    var currentPage:Int = 1
    var lastPage:Int = 1
    var logtitude:Double?
    var lattitude:Double?
    var arrays = [Around]()
    lazy var geocoder = CLGeocoder()
    var textLocation:String?{
        didSet{
        textInput = textLocation
        }
    }
    var current: CLLocationCoordinate2D?
    var textInput: String?
    var currentLocation: CLLocationCoordinate2D?{
    didSet{
        current = currentLocation
        }
    }
    var searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
    var work = [WorkName]()
    @IBOutlet weak var aroundTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        aroundTableView.register(UINib(nibName:NibWorkTableViewCell,bundle: nil), forCellReuseIdentifier: workCellID)
        aroundTableView.addSubview(handleRefresh)
        arWork.setupView()
        searchBar.delegate = self
        aroundTableView.separatorStyle = .none
        searchBar.placeholder = "SearchLocation".localize
        searchBar.barTintColor = .white
        searchBar.tintColor =  UIColor.colorWithRedValue(redValue: 47, greenValue: 186, blueValue: 194, alpha: 1)
        self.aroundTableView.rowHeight = UITableViewAutomaticDimension
        self.aroundTableView.estimatedRowHeight = 100.0
        setup()
        configSearchBar()
        loadData { (_,_) in
            
        }
        if #available(iOS 10.0, *) {
            aroundTableView.refreshControl = handleRefresh
        } else {
            // Fallback on earlier versions
        }
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
    func loadData(_ completion:((_ arounds: [Around], _ error: Error?)->Void)?) {
        guard let longitude = current?.longitude, let latitude = current?.latitude else {
            AlertStandard.sharedInstance.showAlertCt(controller: self, title: "", message: "PleasegotoSettings".localize, completion: {
                UIApplication.shared.openURL(NSURL(string:UIApplicationOpenSettingsURLString)! as URL)
            })
            return
        }
        self.loadingView.show()
        let distance = Int(arWork.slider.value)
        let apiService = APIService.shared
        let param:Parameters = ["lat": latitude,
                                "lng": longitude,
                                "minDistance":0,
                                "maxDistance":distance]
        apiService.getAllAround(url: APIPaths().urlGetListAround(), method: .get, parameters: param, encoding: URLEncoding.default) { (json, string) in
            self.loadingView.close()
            var arounds = [Around]()
            var error: Error?
            
            // success
            if let jsons = json?.array{
                arounds = jsons.map({ (json) -> Around in
                    return Around(json: json)
                })
            }
            // failure
            else {
                // TODO: should specify error clearly
                error = Error()
            }
            
            self.arrays = arounds
            self.aroundTableView.reloadData()
            
            if let _ = error {
                AlertStandard.sharedInstance.showAlert(controller: self, title: "", message: "notResultFound".localize)
            } else if arounds.count == 0 {
                AlertStandard.sharedInstance.showAlert(controller: self, title: "", message: "notResultFound".localize)
            }
            
            completion?(arounds, error)
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
        button.titleLabel?.font = fontSize.fontName(name: .regular, size: sizeFive)
        button.addTarget(self, action: #selector(selectButton), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        
    }
    func selectButton() {
        searchBar.resignFirstResponder()
        searchText()
    }
    // Get longtitude and lattitue
//    func forwardGeocoding(){
//        loadingView.show()
//        guard let locationString = textInput else{return}
//        APIService.shared.getLocation(url: locationString) { (json, error) in
//            self.loadingView.close()
//            guard let geometry = json?[0]["geometry"].dictionary else{return}
//            guard let location = geometry["location"]?.dictionary else{return}
//            guard let lat = location["lat"], let lng = location["lng"] else{return}
//            self.currentLocation?.latitude = lat.double!
//            self.currentLocation?.longitude = lng.double!
//        }
//    }

    func searchText() {
        if self.textInput == nil {
            loadData({ (_, _) in
                
            })
        }
        
        guard let text = self.textInput else {
            return
        }
        
        loadingView.show()
        
        geocoder.geocodeAddressString(text) {  (placeMarks, error) in
            self.loadingView.close()
            self.currentLocation = nil
            guard let placemarks = placeMarks, let location = placemarks[0].location, error == nil else {
                //self.loadingView.close()
                AlertStandard.sharedInstance.showAlert(controller: self, title: "", message: "Somethingwentwrong".localize)
                return
            }
            
            
            
            self.currentLocation = location.coordinate
            self.loadData { (arounds, error) in
              
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
        cell.amountWork.text = "\(amount)" + " " + "Work".localize
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
            vc.currentLocation = current
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
        self.textLocation = searchText
        print(searchText)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchText()
    }
}



