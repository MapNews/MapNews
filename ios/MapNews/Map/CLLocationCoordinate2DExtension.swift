//
//  CLLocationCoordinate2DExtension.swift
//  MapNews
//
//  Created by Hol Yin Ho on 1/6/20.
//  Copyright © 2020 Hol Yin Ho. All rights reserved.
//
import GoogleMaps

extension CLLocationCoordinate2D {
    static func from(coordinates: Coordinates) -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: CLLocationDegrees(exactly: coordinates.lat) ?? 0,
            longitude: CLLocationDegrees(exactly: coordinates.long) ?? 0
        )
    }
}
