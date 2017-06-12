//
//  LocationTableViewController.swift
//  GV24
//
//  Created by admin on 6/12/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import MapKit

class LocationTableViewController: UITableViewController {
    
    var matchingItems: [MKMapItem] = []
    var mapView: MKMapView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib(nibName: "MapViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MapViewCell
        
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.latLabel.text = selectedItem.name
        cell.longLabel.text = "lat: " + String(describing: selectedItem.coordinate.latitude) + " - long:" + String(describing: selectedItem.coordinate.longitude)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true, completion: nil)
    }
}

extension LocationTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView, let searchBarText = searchController.searchBar.text else {
            return
        }
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBarText
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { (response, _) in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }
}
