//
//  ViewController.swift
//  MapNews
//
//  Created by Hol Yin Ho on 18/5/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let camera = GMSCameraPosition.camera(withLatitude: 1.3521,
                                              longitude: 103.8198,
                                              zoom: 10)
        let mapView = GMSMapView.map(withFrame: self.view.bounds, camera: camera)
        view.addSubview(mapView)
    }


}

