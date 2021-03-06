//
//  MapViewController.swift
//  GV24
//
//  Created by admin on 6/12/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import IoniconsSwift
import Alamofire

class MapViewController: BaseViewController {
    @IBOutlet weak var findMe: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var lbAddress: UILabel!
    var resultsArray = [String]()
    var locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    var zoomLevel: Float = 15.0
    var placesClient: GMSPlacesClient!
    var didFindMyLocation = false
    var likelyPlaces: [GMSPlace] = []
    var selectedPlace: GMSPlace?
    lazy var geocoder = CLGeocoder()
    var searchController = UISearchBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
    var resultView: UITextView?
    var arrays = [Around]()
    var arrayMap = [Around]()
    @IBAction func findMeAction(_ sender: Any) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTheLocationManager()
        configurationSearchBar()
    }
    override func setupViewBase() {
        super.setupViewBase()
        self.title = "Nearby".localize
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let current = currentLocation else {return}
        let marker = GMSMarker(position: current)
        mapView.animate(toLocation: current)
        marker.map = mapView
    }
    func initializeTheLocationManager(){
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        mapView.delegate = self
        placesClient = GMSPlacesClient.shared()
    }
    func configurationSearchBar() {
        //        searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.placeholder = "SearchLocation".localize
        searchController.barTintColor = .white
        searchController.tintColor =  UIColor.colorWithRedValue(redValue: 47, greenValue: 186, blueValue: 194, alpha: 1)
        let subView = UIView(frame: CGRect(x: 0, y: 64.0, width:UIScreen.main.bounds.width, height: 45.0))
        subView.addSubview(searchController)
        view.addSubview(subView)
        searchController.sizeToFit()
        //    searchController?.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        self.extendedLayoutIncludesOpaqueBars = true
        self.edgesForExtendedLayout = .top
        let setting = Ionicons.iosSettings.image(32).imageWithColor(color: UIColor.colorWithRedValue(redValue: 45, greenValue: 166, blueValue: 173, alpha: 1))
        let button = UIButton(type: .custom)
        button.setImage(setting, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.addTarget(self, action: #selector(MapViewController.addTapped), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        
    }
    func loadData(lng:Double,lat:Double) {
        let apiService = APIService.shared
        let param:[String:Double] = ["lng": lng,"lat": lat,"minDistance":0,"maxDistance":10]
        apiService.getAllAround(url: APIPaths().urlGetListAround(), method: .get, parameters: param, encoding: URLEncoding.default) { (json, string) in
            if let jsonArray = json?.array{
                for data in jsonArray{
                    self.arrayMap.append(Around(json: data))
                }
            }
        }
    }
    func handle(location : CLLocationCoordinate2D){
        self.hideKeyboard()
        self.mapView.animate(toLocation: location)
        self.currentLocation = location
        
    }
    // MARK: button filter longtitude and latitude
    func addTapped() {
        let around = WorkAroundController(nibName: NibWorkAroundController, bundle: nil)
        around.currentLocation = currentLocation
        navigationController?.pushViewController(around, animated: true)
    }
    func hideKeyboard(){
        self.view.endEditing(true)
    }
}
extension MapViewController: CLLocationManagerDelegate {
    // MARK: - Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,longitude: location.coordinate.longitude,zoom: zoomLevel)
        currentLocation = location.coordinate
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        }else{
            mapView.animate(to: camera)
        }
    }
    
    
    
    
    // MARK: - Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    private func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}

extension MapViewController:GMSMapViewDelegate{
//        //MARK: GMSMapViewDelegate Implimentation.
//        internal func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D){
//            plotMarker(AtCoordinate: CLLocationCoordinate2D.init(latitude: coordinate.latitude, longitude: coordinate.longitude),onMapView: mapView)
//        }
//        //MARK: Plot Marker Helper
//        private func plotMarker(AtCoordinate coordinate : CLLocationCoordinate2D, onMapView vwMap : GMSMapView) -> Void{
//            mapView.clear()
//            let marker = GMSMarker(position: coordinate)
//            marker.map = vwMap
//        }
}
extension MapViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        hideKeyboard()
        loadingView.show()
        guard let text = searchBar.text else {return}
        APIService.shared.getLocation(url: text) { (json, error) in
            self.loadingView.close()
            if json != nil {
                guard let geometry = json?[0]["geometry"].dictionary else{return}
                guard let location = geometry["location"]?.dictionary else{return}
                guard let lat = location["lat"]?.double, let lng = location["lng"]?.double else{
                    AlertStandard.sharedInstance.showAlert(controller: self, title: "", message: "Somethingwentwrong".localize)
                    return
                }
                self.currentLocation?.latitude = lat
                self.currentLocation?.longitude = lng
                let around = WorkAroundController(nibName: NibWorkAroundController, bundle: nil)
                around.currentLocation = self.currentLocation
                self.navigationController?.pushViewController(around, animated: true)
            }else{
                AlertStandard.sharedInstance.showAlert(controller: self, title: "", message: "Somethingwentwrong".localize)
            }
            
            
        }
    }
    
}

