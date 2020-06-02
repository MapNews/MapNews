//
//  MapNewsMarker.swift
//  MapNews
//
//  Created by Hol Yin Ho on 2/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//
import GoogleMaps

class MapNewsMarker: GMSMarker {
    let locationName: String

    init(at locationName: String, position: CLLocationCoordinate2D) {
        self.locationName = locationName
        super.init()
        self.position = position
    }
}
