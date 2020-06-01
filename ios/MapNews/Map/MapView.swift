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
        GMSCameraPosition.camera(withLatitude: 1.3521, longitude: 103.8198, zoom: 3)
    static let defaultLocation = CLLocationCoordinate2D.from(coordinates: Coordinates(lat: 1.3521, long: 103.8198))

    var location: CLLocationCoordinate2D? {
        didSet {
            if let currentLocation = location {
                camera = GMSCameraPosition.camera(withTarget: currentLocation, zoom: 3)
            }
        }
    }

    static func createMapView(frame: CGRect) -> MapView {
        let mapView = super.map(withFrame: frame, camera: MapView.singaporeCamera) as! MapView
        mapView.location = defaultLocation
        mapView.settings.zoomGestures = true
        return mapView
    }
}
