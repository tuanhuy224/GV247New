//
//  MapViewController.swift
//  GV24
//
//  Created by admin on 6/12/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark)
}

class MapViewController: BaseViewController {
    let locationSearchTable = LocationTableViewController()
    @IBOutlet weak var mapView: MKMapView!
    var resultSearchController: UISearchController? = nil
    var locationManager: CLLocationManager?
    var searchBar:UISearchBar?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.decorate()
    }
    
    override func decorate() {
        super.decorate()
        locationSearchTable.mapView = mapView
        resultSearchController =  UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        searchBar = resultSearchController!.searchBar
        searchBar?.sizeToFit()
        searchBar?.placeholder = "Search for places"
        searchBar?.barTintColor = UIColor.lightGray
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.startUpdatingLocation()
        }

    }
    override func setupViewBase() {
        super.setupViewBase()
        self.navigationItem.hidesBackButton = true
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0] as CLLocation
        print("Lat: \(userLocation.coordinate.latitude) - Long: \(userLocation.coordinate.longitude)")
        let center = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegionMake(center, span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude)
        annotation.title = "Current Location"
        mapView.addAnnotation(annotation)
    }
}

