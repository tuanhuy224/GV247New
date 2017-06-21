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

class MapViewController: BaseViewController,UISearchDisplayDelegate {
    @IBOutlet weak var findMe: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var lbAddress: UILabel!
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var zoomLevel: Float = 15.0
    var placesClient: GMSPlacesClient!
    var didFindMyLocation = false
    var likelyPlaces: [GMSPlace] = []
    var selectedPlace: GMSPlace?
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var arrays = [Around]()
    @IBAction func findMeAction(_ sender: Any) {
       
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTheLocationManager()
        configurationSearchBar()
    }
    override func setupViewBase() {
        super.setupViewBase()
        self.title = "Around".localize
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
        resultsViewController = GMSAutocompleteResultsViewController()
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        let subView = UIView(frame: CGRect(x: 0, y: 64.0, width:UIScreen.main.bounds.width, height: 45.0))
        subView.addSubview((searchController?.searchBar)!)
        view.addSubview(subView)
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
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
    // Populate the array with the list of likely places.
    func listLikelyPlaces() {
        likelyPlaces.removeAll()
        placesClient.currentPlace(callback: { (placeLikelihoods, error) -> Void in
            if let error = error {
                print("Current Place error: \(error.localizedDescription)")
                return
            }
            if let likelihoodList = placeLikelihoods {
                for likelihood in likelihoodList.likelihoods {
                    let place = likelihood.place
                    self.likelyPlaces.append(place)
                }
            }
        })
    }
    // MARK: button filter longtitude and latitude
    func addTapped() {
        let around = WorkAroundController(nibName: NibWorkAroundController, bundle: nil)
        around.arrays = arrays
        navigationController?.pushViewController(around, animated: true)
    }
}
extension MapViewController: CLLocationManagerDelegate {
    // MARK: - Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,longitude: location.coordinate.longitude,zoom: zoomLevel)
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        }else{
            mapView.animate(to: camera)
        }
        listLikelyPlaces()
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
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
    }
}

