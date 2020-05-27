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
    static let defaultLocation = Coordinates(lat: 1.3521, long: 103.8198)

    var location: Coordinates? {
        didSet {
            self.camera = GMSCameraPosition.camera(
                withLatitude: location?.lat ?? MapView.defaultLocation.lat,
                longitude: location?.long ?? MapView.defaultLocation.long,
                zoom: 5
            )
        }
    }

    static func createMapView(frame: CGRect) -> MapView {
        let mapView = super.map(withFrame: frame, camera: MapView.singaporeCamera) as! MapView
        mapView.location = defaultLocation
        return mapView
    }
}
