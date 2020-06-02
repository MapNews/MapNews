//
//  MapView.swift
//  MapNews
//
//  Created by Hol Yin Ho on 21/5/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//

import GoogleMaps

class MapNewsView: GMSMapView {
    private let singaporeCamera =
        GMSCameraPosition.camera(withLatitude: 1.3521, longitude: 103.8198, zoom: 3)
    private let defaultLocation = CLLocationCoordinate2D.from(coordinates: Coordinates(lat: 1.3521, long: 103.8198))

    var location: CLLocationCoordinate2D? {
        didSet {
            if let currentLocation = location {
                camera = GMSCameraPosition.camera(withTarget: currentLocation, zoom: 8)
            }
        }
    }
    
    var mapBounds: GMSCoordinateBounds {
        let visibleRegion = projection.visibleRegion()
        let northEast = visibleRegion.farRight
        let southWest = visibleRegion.nearLeft
        return GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
    }

    override init(frame: CGRect) {
        location = defaultLocation
        super.init(frame: frame)
        camera = singaporeCamera
        settings.zoomGestures = true
    }

    required init?(coder: NSCoder) {
        return nil
    }
}
