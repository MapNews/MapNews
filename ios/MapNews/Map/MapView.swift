//
//  MapView.swift
//  MapNews
//
//  Created by Hol Yin Ho on 21/5/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//

import GoogleMaps

class MapView: GMSMapView {
    static let singaporeCamera =
        GMSCameraPosition.camera(withLatitude: 1.3521, longitude: 103.8198, zoom: 10)

    static func createMapView(frame: CGRect) -> MapView {
        super.map(withFrame: frame, camera: MapView.singaporeCamera) as! MapView
    }
}
