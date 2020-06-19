//
//  MapView.swift
//  MapNews
//
//  Created by Hol Yin Ho on 21/5/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//

import GoogleMaps

class MapNewsView: GMSMapView {
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
        location = MapConstants.singaporeCoordinates
        super.init(frame: frame)
        camera = MapConstants.singaporeCamera
        settings.zoomGestures = true
        AccessibilityIdentifierUtil.setIdentifier(map: self, to: "MapNewsView")
    }

    required init?(coder: NSCoder) {
        return nil
    }
}
