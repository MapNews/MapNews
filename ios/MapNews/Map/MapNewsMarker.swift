//
//  MapNewsMarker.swift
//  MapNews
//
//  Created by Hol Yin Ho on 2/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//
import GoogleMaps

class MapNewsMarker: GMSMarker {
    let location: CountryCoordinateDTO

    init(at location: CountryCoordinateDTO) {
        self.location = location
        super.init()
        self.position = CLLocationCoordinate2D.from(location.coordinates)
    }
}
