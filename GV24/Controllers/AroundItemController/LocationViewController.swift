//
//  LocationViewController.swift
//  GV24
//
//  Created by dinhphong on 8/30/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import UIKit
import GooglePlacePicker



class LocationViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePickerViewController(config: config)
        
        self.view.addSubview(placePicker.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
}
