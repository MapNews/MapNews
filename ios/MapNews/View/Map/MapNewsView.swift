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
                camera = GMSCameraPosition.camera(withTarget: currentLocation, zoom: 3)
            }
        }
    }
    
    var mapBounds: GMSCoordinateBounds {
        let visibleRegion = projection.visibleRegion()
        let northEast = visibleRegion.farRight
        let southWest = visibleRegion.nearLeft
        return GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
    }

    init(frame: CGRect, location: CLLocationCoordinate2D) {
        self.location = location
        super.init(frame: frame)
        camera = MapConstants.singaporeCamera
        settings.zoomGestures = true
        AccessibilityIdentifierUtil.setIdentifier(map: self, to: Identifiers.mapNewsIdentifier)
    }

    required init?(coder: NSCoder) {
        return nil
    }
}
